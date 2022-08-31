import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HybridTextField extends StatelessWidget {
  const HybridTextField({
    required this.controller,
    this.placeholder,
    this.readOnly = false,
    this.isForPassword = false,
    this.inputType,
    Key? key,
  }) : super(key: key);

  final TextEditingController controller;
  final String? placeholder;
  final bool readOnly;
  final bool isForPassword;
  final TextInputType? inputType;

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return ListTile(
        title: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: placeholder != null ? Text(placeholder!) : null,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: CupertinoTextField(
            controller: controller,
            padding: const EdgeInsets.all(10),
            readOnly: readOnly,
            obscureText: isForPassword,
            enableSuggestions: !isForPassword,
            autocorrect: false,
            clearButtonMode: OverlayVisibilityMode.editing,
          ),
        ),
      );
    } else {
      return ListTile(
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              label: placeholder != null ? Text(placeholder!) : null,
              suffixIcon: controller.text.isNotEmpty
                  ? GestureDetector(onTap: () => controller.clear(), child: const Icon(Icons.close))
                  : null,
            ),
            keyboardType: inputType,
            readOnly: readOnly,
            obscureText: isForPassword,
            enableSuggestions: !isForPassword,
            autocorrect: !isForPassword,
          ),
        ),
      );
    }
  }
}
