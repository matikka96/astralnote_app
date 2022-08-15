import 'package:astralnote_app/core/extensions/extensions.dart';
import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    this.showTopPadding = true,
    this.showBottomPadding = true,
    this.showBorder = true,
    Key? key,
  }) : super(key: key);

  factory CustomDivider.empty() => const CustomDivider(showBorder: false);

  factory CustomDivider.emptySmall() => const CustomDivider(showBorder: false, showBottomPadding: false);

  final bool showTopPadding;
  final bool showBottomPadding;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    final dividerHeight = context.theme.dividerTheme.space ?? 16;
    final thickness = context.theme.dividerTheme.thickness ?? 0.0;

    return Column(
      children: [
        if (showTopPadding) SizedBox(height: dividerHeight / 2),
        if (showBorder)
          Container(
            height: thickness,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: thickness, color: context.theme.dividerColor),
              ),
            ),
          ),
        if (showBottomPadding) SizedBox(height: dividerHeight / 2),
      ],
    );
  }
}
