import 'package:flutter/material.dart';

class GlobalListeners extends StatelessWidget {
  const GlobalListeners({
    required this.child,
    Key? key,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
    // return AuthGuard(
    //   // navigator: navigator,
    //   child: child,
    // );
  }
}
