import 'dart:async';

import 'package:astralnote_app/core/extensions/extensions.dart';
import 'package:astralnote_app/global/blocks/lifecycle/lifecycle_cubit.dart';
import 'package:astralnote_app/global/blocks/notes/notes_cubit.dart';
import 'package:astralnote_app/global/blocks/remote_config/remote_config_cubit.dart';
import 'package:astralnote_app/global/blocks/user/user_cubit.dart';
import 'package:astralnote_app/global/listeners/app_activity_listener.dart';
import 'package:astralnote_app/infrastructure/auth_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LifecycleListener extends StatelessWidget {
  const LifecycleListener({
    required this.child,
    Key? key,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    void _syncNotesPeriodicallyLauncher() {
      context.read<NotesCubit>().onRefreshNotesRemote();
      Timer.periodic(const Duration(seconds: 600), (timer) {
        if (!context.read<LifecycleCubit>().state.isOnlineAndActiveAndAuthenticated) {
          timer.cancel();
        } else {
          context.read<NotesCubit>().onRefreshNotesRemote();
        }
      });
    }

    return AppActivityListener(
      onResumed: () => context.read<LifecycleCubit>().onAppActivityStatusChanged(AppActivityStatus.active),
      onInterrupted: () => context.read<LifecycleCubit>().onAppActivityStatusChanged(AppActivityStatus.inactive),
      child: BlocListener<LifecycleCubit, LifecycleState>(
        listener: (context, state) {
          switch (state.isOnlineAndActiveAndAuthenticated) {
            case true:
              // Trigger repeated timer for loading notes from cloud when online, app active & user authenticated
              _syncNotesPeriodicallyLauncher();
              context.read<UserCubit>().onLoadCurrentUser();
              break;
            case false:
          }

          switch (state.userIsAuthenticated) {
            case true:
              break;
            case false:
              context.read<NotesCubit>().onDispose();
              context.read<UserCubit>().onDispose();
              break;
          }

          switch (state.appIsOnline) {
            case true:
              context.read<NotesCubit>().onOnlineStatusChanged(isOnline: true); // TODO: Subscribe from NotesCubit
              context.read<RemoteConfigCubit>().onLoadRemoteConfig();
              break;
            case false:
              context.read<NotesCubit>().onOnlineStatusChanged(isOnline: false); // TODO: Subscribe from NotesCubit
              context.read<RemoteConfigCubit>().onDispose();
              break;
          }
        },
        child: child,
      ),
    );
  }
}
