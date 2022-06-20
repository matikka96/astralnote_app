import 'package:astralnote_app/global/blocks/auth/auth_cubit.dart';
import 'package:astralnote_app/global/blocks/connectivity/connectivity_cubit.dart';
import 'package:astralnote_app/global/blocks/notes/notes_cubit.dart';
import 'package:astralnote_app/infrastructure/auth_repository.dart';
import 'package:astralnote_app/infrastructure/network_monitor_repository.dart';
import 'package:astralnote_app/infrastructure/notes_local_repository.dart';
import 'package:astralnote_app/infrastructure/secure_storage_repository.dart';
import 'package:astralnote_app/modules/connectivity_module.dart';
import 'package:astralnote_app/modules/dio_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GlobalBlocs extends StatelessWidget {
  const GlobalBlocs({required this.child, Key? key}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          lazy: false,
          create: (_) => AuthCubit(
            authRepository: AuthRepository(dioModule: DioModule()),
            secureStorageRepository: SecureStorageRepository(),
          ),
        ),
        BlocProvider<ConnectivityCubit>(
          lazy: false,
          create: (_) => ConnectivityCubit(
            networkMonitorRepository: NetworkMonitorRepository(connectivityModule: ConnectivityModule()),
          ),
        ),
        BlocProvider<NotesCubit>(
          create: (_) => NotesCubit(
            notesLocalRepository: NotesLocalRepository(),
          ),
        ),
      ],
      child: child,
    );
  }
}
