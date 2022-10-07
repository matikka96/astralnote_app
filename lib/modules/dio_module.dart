import 'dart:developer';

import 'package:astralnote_app/domain/auth/dto/auth_dto.dart';
import 'package:astralnote_app/env.dart';
import 'package:astralnote_app/infrastructure/auth_repository.dart';
import 'package:astralnote_app/infrastructure/directus_connector_service.dart';
import 'package:astralnote_app/infrastructure/secure_storage_repository.dart';
import 'package:dio/dio.dart';

class DioModule {
  DioModule({
    required AuthRepository authRepository,
    required SecureStorageRepository secureStorageRepository,
  })  : _authRepository = authRepository,
        _secureStorageRepository = secureStorageRepository;

  final AuthRepository _authRepository;
  final SecureStorageRepository _secureStorageRepository;

  Dio get instance {
    final dio = Dio(BaseOptions(baseUrl: Environment().config.backendUrl));

    dio.interceptors.addAll([
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final accessToken = await _secureStorageRepository.getWithKey(StorageKeys.accessToken);
          options.headers["Authorization"] = "Bearer $accessToken";
          return handler.next(options);
        },
        onError: (e, handler) async {
          if (e.response?.statusCode == 401) {
            final refreshToken = await _secureStorageRepository.getWithKey(StorageKeys.refreshToken);
            final directusAuthConnector = DirectusConnectorService.auth();
            final body = {'refresh_token': refreshToken};
            final rejectOrRefreshToken = await directusAuthConnector.post(collection: 'refresh', body: body);
            return rejectOrRefreshToken.fold(
              (error) async {
                await _authRepository.logout();
                log(e.toString());
                handler.reject(e);
              },
              (authJson) async {
                final authDTO = AuthDTO.fromJson(authJson);
                final auth = authDTO.toDomain();
                await _secureStorageRepository.setWithKey(StorageKeys.accessToken, auth.accessToken.toString());
                await _secureStorageRepository.setWithKey(StorageKeys.refreshToken, auth.refreshToken.toString());
                final retryRequest = await dio.request(
                  e.requestOptions.path,
                  data: e.requestOptions.data,
                  queryParameters: e.requestOptions.queryParameters,
                  options: Options(method: e.requestOptions.method, headers: e.requestOptions.headers),
                );
                handler.resolve(retryRequest);
              },
            );
          }
        },
      ),
      if (Environment().isDev)
        LogInterceptor(
          request: false,
          requestHeader: true,
          responseHeader: false,
          responseBody: true,
          logPrint: (request) {
            log('> > > >');
            log(request.toString());
          },
        ),
    ]);

    return dio;
  }
}
