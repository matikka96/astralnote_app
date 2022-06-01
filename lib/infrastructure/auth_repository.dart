import 'package:astralnote_app/infrastructure/secure_storage_repository.dart';
import 'package:astralnote_app/models/auth/auth.dart';
import 'package:astralnote_app/models/auth/dto/auth_dto.dart';
import 'package:astralnote_app/modules/dio_module.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class AuthRepository {
  static AuthRepository? _instance;

  factory AuthRepository() => _instance ??= AuthRepository._();

  AuthRepository._();

  Future<Either<AuthError, Auth>> login({required String email, required String password}) async {
    try {
      final body = {'email': email, 'password': password};
      final response = await DioModule().tokenDio.post('/auth/login', data: body);
      final authDTO = AuthDTO.fromJson(response.data);
      final auth = authDTO.data.toDomain();
      return right(auth);
    } catch (e) {
      if (e is DioError && e.response?.statusCode == 400) return left(AuthError.userNotExist);
      if (e is DioError && e.response?.statusCode == 401) return left(AuthError.invalidCredentials);
      return left(AuthError.unexpected);
    }
  }

  Future<Either<AuthError, Auth>> refreshAccessToken({required String refreshToken}) async {
    try {
      final body = {'refresh_token': refreshToken};
      final response = await DioModule().tokenDio.post('/auth/refresh', data: body);
      final authDTO = AuthDTO.fromJson(response.data);
      final auth = authDTO.data.toDomain();
      await SecureStorageRepository().setWithKey(StorageKeys.accessToken, auth.accessToken.toString());
      await SecureStorageRepository().setWithKey(StorageKeys.refreshToken, auth.refreshToken.toString());
      return right(auth);
    } catch (e) {
      if (e is DioError && e.response?.statusCode == 400) return left(AuthError.invalidPayload);
      if (e is DioError && e.response?.statusCode == 401) return left(AuthError.invalidCredentials);
      return left(AuthError.unexpected);
    }
  }
}
