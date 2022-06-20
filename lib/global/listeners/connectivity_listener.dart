import 'package:astralnote_app/global/blocks/connectivity/connectivity_cubit.dart';
import 'package:astralnote_app/global/blocks/notes/notes_cubit.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConnectivityListener extends StatelessWidget {
  const ConnectivityListener({
    required this.child,
    Key? key,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final notesCubit = context.read<NotesCubit>();

    return BlocListener<ConnectivityCubit, ConnectivityState>(
      listener: (context, state) {
        state.when(
          offline: () => notesCubit.setSyncStatus(syncActive: false),
          online: () => notesCubit.setSyncStatus(syncActive: true),
        );
      },
      child: child,
    );
  }
}
