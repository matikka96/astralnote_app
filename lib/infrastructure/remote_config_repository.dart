import 'package:astralnote_app/domain/generic_error.dart';
import 'package:astralnote_app/domain/remote_config/dto/remote_config_dto.dart';
import 'package:astralnote_app/domain/remote_config/remote_config.dart';
import 'package:astralnote_app/infrastructure/directus_connector_service.dart';
import 'package:dartz/dartz.dart';

class RemoteConfigRepository {
  RemoteConfigRepository({
    required DirectusConnectorService publicDataConnector,
  }) : _publicDataConnector = publicDataConnector;

  final DirectusConnectorService _publicDataConnector;
  static const _collection = 'app_config';

  Future<Either<GenericError, RemoteConfig>> getRemoteConfig() async {
    final failureOrAppConfig = await _publicDataConnector.getOne(collection: _collection, query: 'fields=*.*');
    return failureOrAppConfig.fold(
      (error) => left(error),
      (appConfigJson) {
        final appConfigDTO = RemoteConfigDTO.fromJson(appConfigJson);
        final appConfig = appConfigDTO.toDomain();
        return right(appConfig);
      },
    );
  }
}
