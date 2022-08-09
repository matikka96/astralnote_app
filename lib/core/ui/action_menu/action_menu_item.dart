import 'dart:io';

import 'package:astralnote_app/core/extensions/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActionMenuItem extends StatelessWidget {
  const ActionMenuItem({
    required this.description,
    required this.onPress,
    this.icon,
    Key? key,
  }) : super(key: key);

  final String description;
  final VoidCallback onPress;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoActionSheetAction(
        onPressed: () {
          onPress.call();
          context.navigator.pop();
        },
        child: Text(description),
      );
    } else {
      return ListTile(
        onTap: () {
          onPress.call();
          context.navigator.pop();
        },
        title: Text(description),
        leading: Icon(icon ?? Icons.circle_outlined),
      );
    }
  }
}
