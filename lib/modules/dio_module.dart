import 'package:astralnote_app/config.dart';
import 'package:astralnote_app/infrastructure/auth_repository.dart';
import 'package:astralnote_app/infrastructure/secure_storage_repository.dart';
import 'package:dio/dio.dart';

class DioModule {
  final dio = createDio();
  final tokenDio = Dio(BaseOptions(baseUrl: Config.backendUrl));

  DioModule._internal();

  static final _singleton = DioModule._internal();

  factory DioModule() => _singleton;

  static Dio createDio() {
    final dio = Dio(BaseOptions(baseUrl: Config.backendUrl));

    dio.interceptors.addAll([
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final accessToken = await SecureStorageRepository().getWithKey(StorageKeys.accessToken);
          options.headers["Authorization"] = "Bearer $accessToken";
          return handler.next(options);
        },
        onError: (DioError e, handler) async {
          if (e.response?.statusCode == 401) {
            final refreshToken = await SecureStorageRepository().getWithKey(StorageKeys.refreshToken);
            final failureOrAuth =
                await AuthRepository(dioModule: DioModule()).refreshAccessToken(refreshToken: refreshToken.toString());
            failureOrAuth.fold(
              (_) {
                // TODO: Trigger logout from here
                handler.reject(e);
              },
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
