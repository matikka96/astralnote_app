import 'dart:developer';
import 'dart:io';

import 'package:astralnote_app/core/extensions/extensions.dart';
import 'package:astralnote_app/core/ui/action_menu/action_menu_item.dart';
import 'package:astralnote_app/core/ui/custom_divider.dart';
import 'package:astralnote_app/core/ui/custom_list.dart';
import 'package:astralnote_app/domain/note/note.dart';
import 'package:astralnote_app/global/blocks/notes/notes_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
          onPress: () => log(note.toString()),
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
            context.readOrNull<NotesCubit>()?.onChangeNoteStatus(note: note, newNoteStatus: NoteStatus.archived);
            if (context.hasActiveParentRoute) context.navigator.pop();
          },
        ),
      ],
    );
  }

  factory ActionMenu.deletedNoteActions(BuildContext context, {required Note note, bool popRoute = false}) {
    return ActionMenu(
      title: note.title,
      actionItems: [
        ActionMenuItem(
          description: 'Restore',
          icon: Icons.restore,
          onPress: () {
            context.readOrNull<NotesCubit>()?.onChangeNoteStatus(note: note, newNoteStatus: NoteStatus.published);
            if (popRoute && context.hasActiveParentRoute) context.navigator.pop();
          },
        ),
        ActionMenuItem(
          description: 'Delete permanently',
          icon: Icons.delete_outline,
          onPress: () async {
            context.readOrNull<NotesCubit>()?.onChangeNoteStatus(note: note, newNoteStatus: NoteStatus.deleted);
            if (popRoute && context.hasActiveParentRoute) context.navigator.pop();
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomListGroup(
                title: title,
                listItems: List.generate(
                  actionItems.length,
                  (index) => CustomListItem(
                    onTap: () {
                      actionItems[index].onPress.call();
                      context.navigator.pop();
                    },
                    title: actionItems[index].description,
                    leading: actionItems[index].icon != null ? Icon(actionItems[index].icon) : null,
                  ),
                ),
              ),
              CustomDivider.empty(),
            ],
          ),
        ),
      );
    }
  }
}

Future<void> showActionMenu(BuildContext context, {required ActionMenu actionMenu, bool vibrate = false}) {
  if (vibrate) HapticFeedback.selectionClick();
  if (Platform.isIOS) {
    return showCupertinoModalPopup(context: context, builder: (_) => actionMenu);
  } else {
    return showModalBottomSheet(context: context, builder: (_) => actionMenu);
  }
}
