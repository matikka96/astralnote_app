import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class FloatingButton extends StatelessWidget {
  const FloatingButton({
    required this.onPressed,
    required this.child,
    super.key,
  });

  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final icon = Icon(PlatformIcons(context).add);

    return Stack(
      children: [
        child,
        SafeArea(
          child: Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 20),
              child: PlatformIconButton(
                onPressed: onPressed,
                padding: EdgeInsets.zero,
                color: Colors.blue,
                icon: Icon(PlatformIcons(context).add),
                cupertino: (_, __) => CupertinoIconButtonData(minSize: 60, borderRadius: BorderRadius.circular(30)),
              ),
              // child: PlatformWidget(
              //   material: (_, __) => IconButton(
              //     onPressed: onPressed,
              //     icon: icon,
              //   ),
              //   cupertino: (_, __) => CupertinoButton(
              //     onPressed: onPressed,
              //     padding: EdgeInsets.zero,
              //     minSize: 60,
              //     borderRadius: BorderRadius.circular(100),
              //     color: Colors.blue,
              //     child: icon,
              //   ),
              // ),
            ),
          ),
        ),
      ],
    );
  }
}
