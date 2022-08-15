import 'package:astralnote_app/core/ui/hybrid_scroll_bar.dart';
import 'package:flutter/material.dart';

class CustomLayout extends StatelessWidget {
  const CustomLayout({
    required this.child,
    this.bottomWidgets,
    Key? key,
  }) : super(key: key);

  factory CustomLayout.scrollable({required Widget child, List<Widget>? bottomWidgets}) {
    return CustomLayout(
      bottomWidgets: bottomWidgets,
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: child,
      ),
    );
  }

  factory CustomLayout.slivers({required List<Widget> slivers, List<Widget>? bottomWidgets}) {
    return CustomLayout(
      bottomWidgets: bottomWidgets,
      child: HybridScrollbar(
        child: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: slivers,
        ),
      ),
    );
  }

  final Widget child;
  final List<Widget>? bottomWidgets;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: child,
          ),
          if (bottomWidgets != null) Column(children: bottomWidgets!),
        ],
      ),
    );
  }
}
