import 'package:astralnote_app/core/extensions/extensions.dart';
import 'package:astralnote_app/global/blocks/local_config/local_config_cubit.dart';
import 'package:astralnote_app/global/blocks/notes/notes_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocalConfigListener extends StatelessWidget {
  const LocalConfigListener({
    required this.child,
    Key? key,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<LocalConfigCubit, LocalConfigState>(
      listenWhen: (previous, current) => previous.sortOrder != current.sortOrder,
      listener: (context, state) {
        context.readOrNull<NotesCubit>()?.onUpdateSortOrder(updatedSortOrder: state.sortOrder);
      },
      child: child,
    );
  }
}
