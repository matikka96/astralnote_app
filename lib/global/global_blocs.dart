import 'package:astralnote_app/global/blocks/auth/auth_cubit.dart';
import 'package:astralnote_app/global/blocks/lifecycle/lifecycle_cubit.dart';
import 'package:astralnote_app/global/blocks/local_config/local_config_cubit.dart';
import 'package:astralnote_app/global/blocks/notes/notes_cubit.dart';
import 'package:astralnote_app/global/blocks/remote_config/remote_config_cubit.dart';
import 'package:astralnote_app/global/blocks/user/user_cubit.dart';
import 'package:astralnote_app/infrastructure/auth_repository.dart';
import 'package:astralnote_app/infrastructure/network_monitor_repository.dart';
import 'package:astralnote_app/infrastructure/notes_local_repository.dart';
import 'package:astralnote_app/infrastructure/notes_remote_repository.dart';
import 'package:astralnote_app/infrastructure/remote_config_repository.dart';
import 'package:astralnote_app/infrastructure/secure_storage_repository.dart';
import 'package:astralnote_app/infrastructure/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GlobalBlocs extends StatelessWidget {
  const GlobalBlocs({
    required this.child,
    Key? key,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          lazy: false,
          create: (_) => AuthCubit(
            authRepository: context.read<AuthRepository>(),
          ),
        ),
        BlocProvider<LifecycleCubit>(
          lazy: false,
          create: (_) => LifecycleCubit(
            networkMonitorRepository: context.read<NetworkMonitorRepository>(),
            authRepository: context.read<AuthRepository>(),
          ),
        ),
        BlocProvider<UserCubit>(
          create: (_) => UserCubit(
            userRepository: context.read<UserRepository>(),
          ),
        ),
        BlocProvider<NotesCubit>(
          create: (_) => NotesCubit(
            notesLocalRepository: context.read<NotesLocalRepository>(),
            notesRemoteRepository: context.read<NotesRemoteRepository>(),
            networkMonitorRepository: context.read<NetworkMonitorRepository>(),
          ),
        ),
        BlocProvider<LocalConfigCubit>(
          lazy: false,
          create: (_) => LocalConfigCubit(
            secureStorageRepository: context.read<SecureStorageRepository>(),
          ),
        ),
        BlocProvider<RemoteConfigCubit>(
          lazy: false,
          create: (_) => RemoteConfigCubit(
            remoteConfigRepository: context.read<RemoteConfigRepository>(),
          ),
        ),
      ],
      child: child,
    );
  }
}
