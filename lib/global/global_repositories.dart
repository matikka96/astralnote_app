import 'package:astralnote_app/env.dart';
import 'package:astralnote_app/infrastructure/auth_repository.dart';
import 'package:astralnote_app/infrastructure/directus_connector_service.dart';
import 'package:astralnote_app/infrastructure/network_monitor_repository.dart';
import 'package:astralnote_app/infrastructure/notes_local_repository.dart';
import 'package:astralnote_app/infrastructure/notes_remote_repository.dart';
import 'package:astralnote_app/infrastructure/remote_config_repository.dart';
import 'package:astralnote_app/infrastructure/secure_storage_repository.dart';
import 'package:astralnote_app/infrastructure/user_repository.dart';
import 'package:astralnote_app/modules/connectivity_module.dart';
import 'package:astralnote_app/modules/dio_module.dart';
import 'package:astralnote_app/modules/secure_storage_module.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GlobalRepositories extends StatelessWidget {
  const GlobalRepositories({required this.child, Key? key}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final publicDio = Dio(BaseOptions(baseUrl: Environment().config.backendUrl));

    final authConnector = DirectusConnectorService.auth();
    final rolesConnector = DirectusConnectorService(dio: publicDio, endpoint: DirectusEndpoint.roles);
    final usersConnector = DirectusConnectorService(dio: publicDio, endpoint: DirectusEndpoint.users);

    final secureStorageRepository = SecureStorageRepository(secureStorageModule: SecureStorageModule());
    final authRepository = AuthRepository(
      secureStorageRepository: secureStorageRepository,
      authConnector: authConnector,
      rolesConnector: rolesConnector,
      usersConnector: usersConnector,
    );

    final dioModule = DioModule(authRepository: authRepository, secureStorageRepository: secureStorageRepository);

    final publicDataConnector = DirectusConnectorService(dio: publicDio, endpoint: DirectusEndpoint.items);
    final dataConnector = DirectusConnectorService(dio: dioModule.instance, endpoint: DirectusEndpoint.items);
    final currentUserConnector = DirectusConnectorService(dio: dioModule.instance, endpoint: DirectusEndpoint.users);

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => authRepository,
        ),
        RepositoryProvider(
          create: (context) => NetworkMonitorRepository(connectivityModule: ConnectivityModule()),
        ),
        RepositoryProvider(
          create: (context) => secureStorageRepository,
        ),
        RepositoryProvider(
          create: (context) => NotesLocalRepository(),
        ),
        RepositoryProvider(
          create: (context) => NotesRemoteRepository(directusItemConnector: dataConnector),
        ),
        RepositoryProvider(
          create: (context) => UserRepository(currentUserConnector: currentUserConnector),
        ),
        RepositoryProvider(
          create: (context) => RemoteConfigRepository(publicDataConnector: publicDataConnector),
        ),
      ],
      child: child,
    );
  }
}
