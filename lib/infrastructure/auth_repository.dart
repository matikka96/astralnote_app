import 'package:astralnote_app/domain/auth/dto/auth_dto.dart';
import 'package:astralnote_app/domain/generic_error.dart';
import 'package:astralnote_app/domain/role/dto/role_dto.dart';
import 'package:astralnote_app/infrastructure/directus_connector_service.dart';
import 'package:astralnote_app/infrastructure/secure_storage_repository.dart';
import 'package:collection/collection.dart';
import 'package:astralnote_app/domain/auth/auth.dart';
import 'package:dartz/dartz.dart';
import 'package:rxdart/rxdart.dart';

enum AuthError { userNotExist, invalidCredentials, userAlreadyExist, invalidPayload, roleNoteFound, unexpected }

enum AuthStatus { uninitialized, unauthenticated, authenticated }

class AuthRepository {
  AuthRepository({
    required SecureStorageRepository secureStorageRepository,
    required DirectusConnectorService authConnector,
    required DirectusConnectorService rolesConnector,
    required DirectusConnectorService usersConnector,
  })  : _secureStorageRepository = secureStorageRepository,
        _authConnector = authConnector,
        _rolesConnector = rolesConnector,
        _usersConnector = usersConnector {
    _init();
  }

  final SecureStorageRepository _secureStorageRepository;
  final DirectusConnectorService _authConnector;
  final DirectusConnectorService _rolesConnector;
  final DirectusConnectorService _usersConnector;

  final _isAuthenticatedController = BehaviorSubject<AuthStatus>();

  Stream<AuthStatus> get isAuthenticatedObservable => _isAuthenticatedController.stream;

  _init() async {
    final refreshToken = await _secureStorageRepository.getWithKey(StorageKeys.refreshToken);
    if (refreshToken != null) {
      _changeAuthenticationStatus(authStatus: AuthStatus.authenticated);
    } else {
      _changeAuthenticationStatus(authStatus: AuthStatus.unauthenticated);
    }
  }

  void _changeAuthenticationStatus({required AuthStatus authStatus}) {
    _isAuthenticatedController.add(authStatus);
  }

  Future<Either<AuthError, Auth>> login({required String email, required String password}) async {
    final body = {'email': email, 'password': password};
    final rejectOrLogin = await _authConnector.post(collection: 'login', body: body);
    return rejectOrLogin.fold(
      (error) => left(AuthError.unexpected),
      (authJson) async {
        final authDTO = AuthDTO.fromJson(authJson);
        final auth = authDTO.toDomain();
        await _secureStorageRepository.setWithKey(StorageKeys.refreshToken, auth.refreshToken);
        await _secureStorageRepository.setWithKey(StorageKeys.accessToken, auth.accessToken);
        _changeAuthenticationStatus(authStatus: AuthStatus.authenticated);
        return right(auth);
      },
    );
  }

  Future<void> logout() async {
    await _secureStorageRepository.removeWithKey(key: StorageKeys.accessToken);
    await _secureStorageRepository.removeWithKey(key: StorageKeys.refreshToken);
    _changeAuthenticationStatus(authStatus: AuthStatus.unauthenticated);
  }

  Future<Either<AuthError, Unit>> signup({
    required String email,
    required String password,
    required String roleId,
  }) async {
    final body = {'email': email, 'password': password, 'role': roleId};
    final failureOrUserCreated = await _usersConnector.post(collection: '', body: body);
    return failureOrUserCreated.fold(
      (error) {
        switch (error) {
          case GenericError.failedValidation:
            return left(AuthError.userAlreadyExist);
          default:
            return left(AuthError.unexpected);
        }
      },
      (_) => right(unit),
    );
  }

  Future<Either<AuthError, String>> getUserRoleId() async {
    final failureOrRoles = await _rolesConnector.getMany(collection: '');
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

  // Methods below are purely for debugging purposes
  Future<void> printTokens() async {
    final refresh = await _secureStorageRepository.getWithKey(StorageKeys.refreshToken);
    final access = await _secureStorageRepository.getWithKey(StorageKeys.accessToken);
    print('Access: $access');
    print('Refresh: $refresh');
  }

  Future<void> breakAccess() async {
    await _secureStorageRepository.removeWithKey(key: StorageKeys.refreshToken);
  }
}
