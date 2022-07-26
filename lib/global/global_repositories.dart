import 'package:astralnote_app/infrastructure/auth_repository.dart';
import 'package:astralnote_app/infrastructure/network_monitor_repository.dart';
import 'package:astralnote_app/infrastructure/notes_local_repository.dart';
import 'package:astralnote_app/infrastructure/notes_remote_repository.dart';
import 'package:astralnote_app/infrastructure/secure_storage_repository.dart';
import 'package:astralnote_app/modules/connectivity_module.dart';
import 'package:astralnote_app/modules/dio_module.dart';
import 'package:astralnote_app/modules/secure_storage_module.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GlobalRepositories extends StatelessWidget {
  const GlobalRepositories({required this.child, Key? key}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final secureStorageRepository = SecureStorageRepository(secureStorageModule: SecureStorageModule());

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthRepository(
            // dioModule: DioModule(),
            secureStorageRepository: secureStorageRepository,
          ),
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
          create: (context) => NotesRemoteRepository(dioModule: DioModule()),
        ),
      ],
      child: child,
    );
  }
}
