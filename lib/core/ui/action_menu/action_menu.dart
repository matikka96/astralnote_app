import 'dart:io';

import 'package:astralnote_app/core/extensions/extensions.dart';
import 'package:astralnote_app/core/ui/action_menu/action_menu_item.dart';
import 'package:astralnote_app/domain/note/note.dart';
import 'package:astralnote_app/global/blocks/notes/notes_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActionMenu extends StatelessWidget {
  const ActionMenu({
    required this.title,
    required this.actionItems,
    Key? key,
  }) : super(key: key);

  final String title;
  final List<ActionMenuItem> actionItems;

  factory ActionMenu.noteActions(BuildContext context, {required Note note}) {
    return ActionMenu(
      title: note.title,
      actionItems: [
        ActionMenuItem(
          description: 'Log note',
          icon: Icons.print,
          onPress: () => print(note),
        ),
        ActionMenuItem(
          description: 'Share',
          icon: Icons.share,
          onPress: () {},
        ),
        ActionMenuItem(
          description: 'Delete',
          icon: Icons.delete_outline,
          onPress: () {
            context.read<NotesCubit>().onNoteDelete(note);
            if (context.hasActiveParentRoute) context.navigator.pop();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoActionSheet(
        title: Text(title),
        actions: actionItems,
        cancelButton: CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () => context.navigator.pop(),
          child: const Text('Cancel'),
        ),
      );
    } else {
      return Material(
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          child: Wrap(
            children: [
              ListTile(title: Text(title, style: Theme.of(context).textTheme.headline5)),
              for (var actionItem in actionItems) ...[
                const Divider(height: 1),
                actionItem,
              ],
            ],
          ),
        ),
      );
    }
  }
}

Future<void> showActionMenu(BuildContext context, {required ActionMenu actionMenu}) {
  HapticFeedback.selectionClick();
  if (Platform.isIOS) {
    return showCupertinoModalPopup(context: context, builder: (_) => actionMenu);
  } else {
    return showModalBottomSheet(context: context, builder: (_) => actionMenu);
  }
}
