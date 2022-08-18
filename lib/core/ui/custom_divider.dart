import 'package:astralnote_app/core/extensions/extensions.dart';
import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    this.showTopPadding = true,
    this.showBottomPadding = true,
    this.showBorder = true,
    this.hasIndent = false,
    Key? key,
  }) : super(key: key);

  factory CustomDivider.empty() => const CustomDivider(showBorder: false);

  factory CustomDivider.emptySmall() => const CustomDivider(showBorder: false, showBottomPadding: false);

  factory CustomDivider.list() {
    return const CustomDivider(
      showBottomPadding: false,
      showTopPadding: false,
      showBorder: true,
      hasIndent: true,
    );
  }

  final bool showTopPadding;
  final bool showBottomPadding;
  final bool showBorder;
  final bool hasIndent;

  @override
  Widget build(BuildContext context) {
    final spacing = context.theme.dividerTheme.space ?? 16;
    final thickness = context.theme.dividerTheme.thickness ?? 0.0;

    return Column(
      children: [
        if (showTopPadding) SizedBox(height: spacing / 2),
        if (showBorder)
          Container(
            height: thickness,
            margin: EdgeInsets.only(left: spacing),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: thickness, color: context.theme.dividerColor),
              ),
            ),
          ),
        if (showBottomPadding) SizedBox(height: spacing / 2),
      ],
    );
  }
}
