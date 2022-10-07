import 'dart:io';

import 'package:astralnote_app/core/extensions/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HybridDialog extends StatelessWidget {
  const HybridDialog({
    required this.title,
    required this.onAccept,
    this.onCancel,
    Key? key,
  }) : super(key: key);

  final String title;
  final VoidCallback onAccept;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        title: Text(title),
        actions: [
          CupertinoDialogAction(
            onPressed: onCancel ?? context.navigator.pop,
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            onPressed: () {
              onAccept();
              context.navigator.pop();
            },
            isDefaultAction: true,
            child: const Text('OK'),
          ),
        ],
      );
    } else {
      return AlertDialog(
        title: Text(title),
        actions: [
          TextButton(
            onPressed: onCancel ?? context.navigator.pop,
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              onAccept();
              context.navigator.pop();
            },
            child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      );
    }
  }
}

Future showHybridDialog(BuildContext context, {required HybridDialog content}) {
  if (Platform.isIOS) {
    return showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => content,
    );
  } else {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => content,
    );
  }
}
