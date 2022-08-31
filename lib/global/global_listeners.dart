import 'package:astralnote_app/global/listeners/lifecycle_listener.dart';
import 'package:astralnote_app/global/listeners/local_config_listener.dart';
import 'package:flutter/material.dart';

class GlobalListeners extends StatelessWidget {
  const GlobalListeners({
    required this.child,
    Key? key,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LifecycleListener(
      child: LocalConfigListener(
        child: child,
      ),
    );
  }
}
