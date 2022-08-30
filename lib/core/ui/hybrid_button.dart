import 'dart:io';

import 'package:astralnote_app/core/extensions/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum HybridButtonType { primary, secondary }

class HybridButton extends StatelessWidget {
  const HybridButton({
    required this.onPressed,
    required this.text,
    this.type = HybridButtonType.primary,
    this.fullWidth = false,
    this.isLoading = false,
    Key? key,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final HybridButtonType type;
  final String text;
  final bool fullWidth;
  final bool isLoading;

  factory HybridButton.secondary({required VoidCallback? onPressed, required String text}) {
    return HybridButton(
      onPressed: onPressed,
      type: HybridButtonType.secondary,
      text: text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final buttonColor = type == HybridButtonType.primary ? context.theme.primaryColor : null;
    final textColor =
        type == HybridButtonType.primary ? context.theme.colorScheme.onSecondary : context.theme.colorScheme.primary;
    final loadingIndicator =
        Platform.isIOS ? CupertinoActivityIndicator(color: textColor) : LinearProgressIndicator(color: textColor);
    final content = isLoading ? loadingIndicator : Text(text, style: TextStyle(color: textColor));

    final iosButton = CupertinoButton(
      onPressed: isLoading ? () {} : onPressed,
      disabledColor: CupertinoColors.systemGrey,
      color: buttonColor,
      child: content,
    );

    final materialButton = MaterialButton(
      height: 50,
      onPressed: isLoading ? () {} : onPressed,
      color: buttonColor,
      textColor: textColor,
      child: content,
    );

    return ListTile(title: Platform.isIOS ? iosButton : materialButton);
  }
}
