import 'package:astralnote_app/core/extensions/extensions.dart';
import 'package:astralnote_app/core/ui/custom_divider.dart';
import 'package:astralnote_app/core/ui/hybrid_switch.dart';
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
    Key? key,
  }) : super(key: key);

  factory CustomListItem.link(BuildContext context, {required String title, required String url}) {
    final obj = {'title': title, 'url': url};
    return CustomListItem(
      onTap: () => context.navigator.pushNamed(
        Routes.webview.name,
        arguments: obj,
      ),
      title: title,
      color: Colors.blue,
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

  @override
  Widget build(BuildContext context) {
    final textColor = color ?? context.theme.listTileTheme.textColor;

    return ListTile(
      title: Text(title, style: TextStyle(color: textColor)),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: trailing != null ? trailing! : null,
      onTap: onTap,
    );
  }
}
