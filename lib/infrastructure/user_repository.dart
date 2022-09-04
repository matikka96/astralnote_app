import 'package:astralnote_app/domain/user/dto/user_dto.dart';
import 'package:astralnote_app/domain/user/user.dart';
import 'package:astralnote_app/infrastructure/directus_connector_service.dart';
import 'package:dartz/dartz.dart';

class UserRepository {
  UserRepository({
    required DirectusConnectorService currentUserConnector,
  }) : _currentUserConnector = currentUserConnector;

  final DirectusConnectorService _currentUserConnector;
  final _collection = 'me';

  Future<Either<DirectusError, User>> getCurrentUser() async {
    final failureOrCurrentUser = await _currentUserConnector.getOne(collection: _collection);
    return failureOrCurrentUser.fold(
      (error) => left(error),
      (userJson) {
        final userDTO = UserDTO.fromJson(userJson);
        final user = userDTO.toDomain();
        return right(user);
      },
    );
  }

  Future<Either<DirectusError, Unit>> deleteCurrentUser({required String userId}) async {
    final failureOrCurrentUser = await _currentUserConnector.delete(collection: '', id: userId);
    return failureOrCurrentUser.fold(
      (error) => left(error),
      (_) => right(unit),
    );
  }

  Future<Either<DirectusError, Unit>> updateUserAcceptedAppInfo({
    required String userId,
    required String appInfoId,
  }) async {
    final body = {'accepted_app_info': appInfoId};
    final failureOrAppInfoUpdated = await _currentUserConnector.patch(collection: _collection, body: body);
    return failureOrAppInfoUpdated.fold(
      (error) => left(error),
      (_) => right(unit),
    );
  }
}
