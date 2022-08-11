import 'package:astralnote_app/config.dart';
import 'package:astralnote_app/domain/auth/dto/auth_dto.dart';
import 'package:astralnote_app/domain/role/dto/role_dto.dart';
import 'package:astralnote_app/infrastructure/directus_connector_service.dart';
import 'package:collection/collection.dart';
import 'package:astralnote_app/domain/auth/auth.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

enum AuthError { userNotExist, invalidCredentials, userAlreadyExist, invalidPayload, roleNoteFound, unexpected }

class AuthRepository {
  AuthRepository({
    required DirectusConnectorService authConnector,
    required DirectusConnectorService rolesConnector,
  })  : _directusAuthConnector = authConnector,
        _directusRolesConnector = rolesConnector;

  final DirectusConnectorService _directusAuthConnector;
  final DirectusConnectorService _directusRolesConnector;

  final Dio _authDio = Dio(BaseOptions(baseUrl: Config.backendUrl));

  Future<Either<AuthError, Auth>> login({required String email, required String password}) async {
    final body = {'email': email, 'password': password};
    final rejectOrLogin = await _directusAuthConnector.post(collection: 'login', body: body);
    return rejectOrLogin.fold(
      (error) => left(AuthError.unexpected),
      (authJson) {
        final authDTO = AuthDTO.fromJson(authJson);
        final auth = authDTO.toDomain();
        return right(auth);
      },
    );
  }

  Future<Either<AuthError, Unit>> signup({
    required String email,
    required String password,
    required String roleId,
  }) async {
    final body = {'email': email, 'password': password, 'role': roleId};
    _directusAuthConnector.post(collection: '', body: body);
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
    final failureOrRoles = await _directusRolesConnector.getMany(collection: '');
    return failureOrRoles.fold(
      (l) => left(AuthError.unexpected),
      (rolesJson) {
        final roles = rolesJson.map((roleJson) => RoleDTO.fromJson(roleJson).toDomain()).toList();
        final userRole = roles.firstWhereOrNull((role) => role.name == 'User');
        if (userRole != null) return right(userRole.id);
        return left(AuthError.unexpected);
      },
    );
  }
}
