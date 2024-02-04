import 'package:flutter/material.dart';

class DialogButtonBar extends StatelessWidget {
  final EdgeInsets? actionsPadding;
  final List<Widget> children;

  /// {@macro flutter.material.alertDialog.actionsAlignment}
  final MainAxisAlignment? alignment;

  /// {@macro flutter.material.alertDialog.actionsOverflowAlignment}
  final OverflowBarAlignment? overflowAlignment;

  /// {@macro flutter.material.alertDialog.actionsOverflowDirection}
  final VerticalDirection? overflowDirection;

  /// {@macro flutter.material.alertDialog.actionsOverflowButtonSpacing}
  final double? overflowButtonSpacing;

  /// {@macro flutter.material.AlertDialog.buttonPadding}
  final EdgeInsetsGeometry? buttonPadding;

  const DialogButtonBar({
    this.actionsPadding,
    super.key,
    required this.children,
    this.alignment,
    this.overflowAlignment,
    this.overflowDirection,
    this.overflowButtonSpacing,
    this.buttonPadding,
  });

  @override
  Widget build(BuildContext context) {
    final double spacing = (buttonPadding?.horizontal ?? 16) / 2;

    final dialogTheme = DialogTheme.of(context);
    final fallbackActionsPadding = Theme.of(context).useMaterial3
        ? const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0)
        : EdgeInsets.all(spacing);

    return Padding(
      padding: actionsPadding ??
          dialogTheme.actionsPadding ??
          fallbackActionsPadding,
      child: OverflowBar(
        alignment: alignment ?? MainAxisAlignment.end,
        spacing: spacing,
        overflowAlignment: overflowAlignment ?? OverflowBarAlignment.end,
        overflowDirection: overflowDirection ?? VerticalDirection.down,
        overflowSpacing: overflowButtonSpacing ?? 0,
        children: children,
      ),
    );
  }
}
