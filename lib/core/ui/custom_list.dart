import 'package:astralnote_app/core/extensions/extensions.dart';
import 'package:astralnote_app/core/ui/action_menu/action_menu.dart';
import 'package:astralnote_app/core/ui/custom_divider.dart';
import 'package:astralnote_app/core/ui/hybrid_switch.dart';
import 'package:astralnote_app/domain/note/note.dart';
import 'package:astralnote_app/router_service.dart';
import 'package:flutter/material.dart';

class CustomListGroup extends StatelessWidget {
  const CustomListGroup({
    this.title,
    required this.listItems,
    Key? key,
  }) : super(key: key);

  final String? title;
  final List<CustomListItem> listItems;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomDivider.emptySmall(),
        if (title != null)
          ListTile(
            title: Text(title!, style: context.theme.textTheme.headline6),
          ),
        for (var listItem in listItems) listItem,
      ],
    );
  }
}

class CustomListItem extends StatelessWidget {
  const CustomListItem({
    required this.title,
    this.subtitle,
    this.trailing,
    this.color,
    this.onTap,
    this.onLongPress,
    Key? key,
  }) : super(key: key);

  factory CustomListItem.note(BuildContext context, {required Note note}) {
    return CustomListItem(
      onTap: () => context.navigator.pushNamed(Routes.viewNote.name, arguments: note),
      onLongPress: () async => showActionMenu(
        context,
        actionMenu: note.status == NoteStatus.published
            ? ActionMenu.noteActions(context, note: note)
            : ActionMenu.deletedNoteActions(context, note: note),
        vibrate: true,
      ),
      title: note.title,
      subtitle: note.subTitle,
      // // We will need this later
      // trailing: Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: const [Icon(Icons.circle, size: 15)],
      // ),
    );
  }

  factory CustomListItem.link(BuildContext context, {required String title, required String url}) {
    final obj = {'title': title, 'url': url};
    return CustomListItem(
      onTap: () => context.navigator.pushNamed(
        Routes.webview.name,
        arguments: obj,
      ),
      title: title,
      color: Colors.blue,
      trailing: const Icon(Icons.arrow_forward_ios),
    );
  }

  factory CustomListItem.switcher({required String title, required bool value, required VoidCallback onChange}) {
    return CustomListItem(
      title: title,
      trailing: HybridSwitch(value: value, onChanged: (_) => onChange()),
    );
  }

  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Color? color;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final textColor = color ?? context.theme.listTileTheme.textColor;

    return ListTile(
      enabled: onTap != null ? true : false,
      onTap: onTap,
      onLongPress: onLongPress,
      title: Text(title, style: TextStyle(color: textColor)),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: trailing != null ? trailing! : null,
    );
  }
}
