import 'package:astralnote_app/config.dart';
import 'package:astralnote_app/infrastructure/auth_repository.dart';
import 'package:astralnote_app/infrastructure/secure_storage_repository.dart';
import 'package:astralnote_app/modules/secure_storage_module.dart';
import 'package:dio/dio.dart';

// TODO: Use of repositories should be refactored

class DioModule {
  final dio = createDio();

  DioModule._internal();
  static final _singleton = DioModule._internal();
  factory DioModule() => _singleton;

  static Dio createDio() {
    final dio = Dio(BaseOptions(baseUrl: Config.backendUrl));
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
            final failureOrAuth = await AuthRepository(secureStorageRepository: secureStorageRepository)
                .refreshAccessToken(refreshToken: refreshToken.toString());
            failureOrAuth.fold(
              (_) => handler.reject(e), // // TODO: Trigger logout from here
              (auth) async {
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
