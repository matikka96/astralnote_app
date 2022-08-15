import 'dart:io';

import 'package:astralnote_app/core/extensions/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HybridSearchField extends StatelessWidget {
  const HybridSearchField({
    required this.controller,
    Key? key,
  }) : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return ListTile(
        title: CupertinoSearchTextField(
          controller: controller,
          onSuffixTap: () {
            controller.clear();
            context.hideKeyboard;
          },
        ),
      );
    } else {
      return ListTile(
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              // icon: const Icon(Icons.search),
              // suffixIcon: Icon(Icons.close),
              prefixIcon: const Icon(Icons.search),
              suffixIcon: controller.text.isNotEmpty
                  ? GestureDetector(onTap: () => controller.clear(), child: const Icon(Icons.close))
                  : null,
            ),
          ),
        ),
      );
    }
  }
}
