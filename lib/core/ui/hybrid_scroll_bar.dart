import 'dart:io';

import 'package:flutter/material.dart';

class HybridScrollbar extends StatelessWidget {
  const HybridScrollbar({
    required this.child,
    Key? key,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return Scrollbar(child: child);
    } else {
      return child;
    }
  }
}
