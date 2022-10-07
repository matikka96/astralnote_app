import 'dart:async';

import 'package:astralnote_app/core/extensions/extensions.dart';
import 'package:astralnote_app/env.dart';
import 'package:astralnote_app/global/blocks/lifecycle/lifecycle_cubit.dart';
import 'package:astralnote_app/global/blocks/notes/notes_cubit.dart';
import 'package:astralnote_app/global/blocks/remote_config/remote_config_cubit.dart';
import 'package:astralnote_app/global/blocks/user/user_cubit.dart';
import 'package:astralnote_app/global/listeners/app_activity_listener.dart';
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
    return AppActivityListener(
      onResumed: () => context.read<LifecycleCubit>().onAppActivityStatusChanged(AppActivityStatus.active),
      onInterrupted: () => context.read<LifecycleCubit>().onAppActivityStatusChanged(AppActivityStatus.inactive),
      child: BlocListener<LifecycleCubit, LifecycleState>(
        listener: (context, state) {
          switch (state.isOnlineAndActiveAndAuthenticated) {
            case true:
              // Trigger repeated timer for loading notes from cloud when online, app active & user authenticated
              syncNotesPeriodicallyLauncher(context);
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
              context.read<RemoteConfigCubit>().onLoadRemoteConfig();
              break;
            case false:
              context.read<RemoteConfigCubit>().onDispose();
              break;
          }
        },
        child: child,
      ),
    );
  }
}

void syncNotesPeriodicallyLauncher(BuildContext context) {
  context.readOrNull<NotesCubit>()?.onRefreshNotesRemote();
  Timer.periodic(Duration(seconds: Environment().config.dataSyncInerval), (timer) {
    if (!context.read<LifecycleCubit>().state.isOnlineAndActiveAndAuthenticated) {
      timer.cancel();
    } else {
      context.readOrNull<NotesCubit>()?.onRefreshNotesRemote();
    }
  });
}
