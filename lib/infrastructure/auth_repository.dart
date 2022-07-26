import 'package:astralnote_app/config.dart';
import 'package:collection/collection.dart';
import 'package:astralnote_app/infrastructure/secure_storage_repository.dart';
import 'package:astralnote_app/domain/auth/auth.dart';
import 'package:astralnote_app/domain/auth/dto/auth_dto.dart';
import 'package:astralnote_app/domain/role/dto/role_dto.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

enum AuthError { userNotExist, invalidCredentials, userAlreadyExist, invalidPayload, roleNoteFound, unexpected }

class AuthRepository {
  AuthRepository({
    required SecureStorageRepository secureStorageRepository,
  }) : _secureStorageRepository = secureStorageRepository;

  final SecureStorageRepository _secureStorageRepository;

  final Dio _authDio = Dio(BaseOptions(baseUrl: Config.backendUrl));

  Future<Either<AuthError, Auth>> login({required String email, required String password}) async {
    try {
      final body = {'email': email, 'password': password};
      final response = await _authDio.post('/auth/login', data: body);
      final authDTO = AuthDTO.fromJson(response.data);
      final auth = authDTO.data.toDomain();
      return right(auth);
    } catch (e) {
      if (e is DioError && e.response?.statusCode == 400) return left(AuthError.userNotExist);
      if (e is DioError && e.response?.statusCode == 401) return left(AuthError.invalidCredentials);
      return left(AuthError.unexpected);
    }
  }

  Future<Either<AuthError, Unit>> signup({
    required String email,
    required String password,
    required String roleId,
  }) async {
    try {
      final body = {'email': email, 'password': password, 'role': roleId};
      await _authDio.post('/users', data: body);
      return right(unit);
    } catch (e) {
      if (e is DioError && e.response?.statusCode == 400) return left(AuthError.userAlreadyExist);
      return left(AuthError.unexpected);
    }
  }

  Future<Either<AuthError, String>> getUserRoleId() async {
    try {
      final response = await _authDio.get('/roles');
      final roleDTO = RoleDTO.fromJson(response.data);
      final roles = roleDTO.data.map((roleDTO) => roleDTO.toDomain()).toList();
      final userRole = roles.firstWhereOrNull((role) => role.name == 'User');
      if (userRole != null) return right(userRole.id);
      return left(AuthError.roleNoteFound);
    } catch (e) {
      return left(AuthError.unexpected);
    }
  }

  Future<Either<AuthError, Auth>> refreshAccessToken({required String refreshToken}) async {
    try {
      final body = {'refresh_token': refreshToken};
      final response = await _authDio.post('/auth/refresh', data: body);
      final authDTO = AuthDTO.fromJson(response.data);
      final auth = authDTO.data.toDomain();
      await _secureStorageRepository.setWithKey(StorageKeys.accessToken, auth.accessToken.toString());
      await _secureStorageRepository.setWithKey(StorageKeys.refreshToken, auth.refreshToken.toString());
      return right(auth);
    } catch (e) {
      if (e is DioError && e.response?.statusCode == 400) return left(AuthError.invalidPayload);
      if (e is DioError && e.response?.statusCode == 401) return left(AuthError.invalidCredentials);
      return left(AuthError.unexpected);
    }
  }
}
