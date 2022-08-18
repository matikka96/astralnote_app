import 'dart:io';

import 'package:astralnote_app/core/extensions/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HybridSwitch extends StatelessWidget {
  const HybridSwitch({
    required this.value,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoSwitch(
        value: value,
        onChanged: (newValue) => onChanged(newValue),
        activeColor: context.theme.primaryColor,
      );
    } else {
      return Switch(
        value: value,
        onChanged: (newValue) => onChanged(newValue),
      );
    }
  }
}
