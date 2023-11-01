import 'package:flutter/material.dart';

/// {@category Utilities}
class TextInheritedIconTheme extends StatelessWidget {
  final Widget child;
  final double iconScaleFactor;

  const TextInheritedIconTheme({
    super.key,
    required this.child,
    this.iconScaleFactor = 1.5,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = DefaultTextStyle.of(context);
    final fontSize = textStyle.style.fontSize;
    final data = IconThemeData(
      color: textStyle.style.color,
      size: fontSize == null ? null : fontSize * iconScaleFactor,
    );

    return IconTheme(data: data, child: child);
  }
}
