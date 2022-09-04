import 'package:astralnote_app/domain/auth/dto/auth_dto.dart';
import 'package:astralnote_app/env.dart';
import 'package:astralnote_app/infrastructure/auth_repository.dart';
import 'package:astralnote_app/infrastructure/directus_connector_service.dart';
import 'package:astralnote_app/infrastructure/secure_storage_repository.dart';
import 'package:astralnote_app/modules/secure_storage_module.dart';
import 'package:dio/dio.dart';

class DioModule {
  DioModule({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  final AuthRepository _authRepository;

  Dio get instance {
    final dio = Dio(
      BaseOptions(baseUrl: Environment().config.backendUrl),
    );

    final secureStorageRepository = SecureStorageRepository(secureStorageModule: SecureStorageModule());

    dio.interceptors.addAll([
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final accessToken = await secureStorageRepository.getWithKey(StorageKeys.accessToken);
          options.headers["Authorization"] = "Bearer $accessToken";
          return handler.next(options);
        },
        onError: (DioError e, handler) async {
          if (e.response?.statusCode == 401) {
            final refreshToken = await secureStorageRepository.getWithKey(StorageKeys.refreshToken);
            final directusAuthConnector = DirectusConnectorService.auth();
            final body = {'refresh_token': refreshToken};
            final rejectOrRefreshToken = await directusAuthConnector.post(collection: 'refresh', body: body);
            return rejectOrRefreshToken.fold(
              (error) {
                _authRepository.logout();
                handler.reject(e);
              },
              (authJson) async {
                final authDTO = AuthDTO.fromJson(authJson);
                final auth = authDTO.toDomain();
                await secureStorageRepository.setWithKey(StorageKeys.accessToken, auth.accessToken.toString());
                await secureStorageRepository.setWithKey(StorageKeys.refreshToken, auth.refreshToken.toString());
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
      LogInterceptor(request: false, requestHeader: false, responseHeader: false, responseBody: false),
    ]);

    return dio;
  }
}
