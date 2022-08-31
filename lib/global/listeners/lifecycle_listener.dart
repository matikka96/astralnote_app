import 'dart:async';

import 'package:astralnote_app/global/blocks/lifecycle/lifecycle_cubit.dart';
import 'package:astralnote_app/global/blocks/notes/notes_cubit.dart';
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
    void _syncNotesPeriodicallyLauncher() {
      context.read<NotesCubit>().onRefreshNotesRemote();
      Timer.periodic(const Duration(seconds: 60), (timer) {
        if (!context.read<LifecycleCubit>().state.repeatedSyncIsOn) {
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
          // Trigger repeated timer for loading notes from cloud when online, app active & user authenticated
          if (state.repeatedSyncIsOn) _syncNotesPeriodicallyLauncher();

          switch (state.connectivity) {
            case ConnectivityStatus.online:
              context.read<NotesCubit>().onOnlineStatusChanged(isOnline: true);
              break;
            case ConnectivityStatus.offline:
              context.read<NotesCubit>().onOnlineStatusChanged(isOnline: false);
              break;
          }
        },
        child: child,
      ),
    );
  }
}
