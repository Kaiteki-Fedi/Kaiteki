import 'package:flutter/material.dart';

class FocusRing extends StatelessWidget {
  const FocusRing({
    super.key,
    required this.focusNode,
    required this.child,
    this.strokeAlign = BorderSide.strokeAlignCenter,
    this.width = 4,
  });

  final FocusNode focusNode;
  final Widget child;
  final double strokeAlign;
  final double width;

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.all(Radius.circular(8.0));

    final theme = Theme.of(context);
    final border = Border.all(
      strokeAlign: strokeAlign,
      color: theme.colorScheme.tertiary,
      width: width,
    );

    return ListenableBuilder(
      listenable: focusNode,
      builder: (_, child) {
        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            border: focusNode.hasPrimaryFocus ? border : null,
          ),
          child: child,
        );
      },
      child: child,
    );
  }
}
