import 'package:flutter/widgets.dart';

class AppActivityListener extends StatefulWidget {
  const AppActivityListener({
    required this.child,
    this.onResumed,
    this.onInterrupted,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final VoidCallback? onResumed;
  final VoidCallback? onInterrupted;

  @override
  State<AppActivityListener> createState() => _AppActivityListenerState();
}

class _AppActivityListenerState extends State<AppActivityListener> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      widget.onResumed?.call();
    } else if (state == AppLifecycleState.inactive) {
      widget.onInterrupted?.call();
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
