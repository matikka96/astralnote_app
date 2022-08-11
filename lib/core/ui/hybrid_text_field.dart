import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HybridTextField extends StatelessWidget {
  const HybridTextField({
    required this.controller,
    this.placeholder,
    this.readOnly = false,
    Key? key,
  }) : super(key: key);

  final TextEditingController controller;
  final String? placeholder;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoTextField(
        controller: controller,
        placeholder: placeholder,
        padding: const EdgeInsets.all(12),
        readOnly: readOnly,
      );
    } else {
      return TextField(
        controller: controller,
        readOnly: readOnly,
        decoration: InputDecoration(label: Text(placeholder ?? '')),
      );
    }
  }
}
