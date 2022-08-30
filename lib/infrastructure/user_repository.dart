import 'package:astralnote_app/domain/generic_error.dart';
import 'package:astralnote_app/domain/user/dto/user_dto.dart';
import 'package:astralnote_app/domain/user/user.dart';
import 'package:astralnote_app/infrastructure/directus_connector_service.dart';
import 'package:dartz/dartz.dart';

class UserRepository {
  UserRepository({
    required DirectusConnectorService currentUserConnector,
  }) : _currentUserConnector = currentUserConnector;

  final DirectusConnectorService _currentUserConnector;

  Future<Either<GenericError, User>> getCurrentUser() async {
    final failureOrCurrentUser = await _currentUserConnector.getOne(collection: 'me');
    return failureOrCurrentUser.fold(
      (error) => left(error),
      (userJson) {
        final userDTO = UserDTO.fromJson(userJson);
        final user = userDTO.toDomain();
        return right(user);
      },
    );
  }

  Future<Either<GenericError, Unit>> deleteCurrentUser({required String userId}) async {
    final failureOrCurrentUser = await _currentUserConnector.delete(collection: '', id: userId);
    return failureOrCurrentUser.fold(
      (error) => left(error),
      (_) => right(unit),
    );
  }
}
