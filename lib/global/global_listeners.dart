import 'package:astralnote_app/global/listeners/auth_guard.dart';
import 'package:astralnote_app/global/listeners/lifecycle_listener.dart';
import 'package:astralnote_app/global/listeners/local_config_listener.dart';
import 'package:astralnote_app/global/listeners/user_listener.dart';
import 'package:flutter/material.dart';

class GlobalListeners extends StatelessWidget {
  const GlobalListeners({
    required this.child,
    required this.navigatorKey,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    return AuthGuard(
      navigator: navigatorKey,
      child: LifecycleListener(
        child: UserListener(
          navigatorKey: navigatorKey,
          child: LocalConfigListener(
            child: child,
          ),
        ),
      ),
    );
  }
}
