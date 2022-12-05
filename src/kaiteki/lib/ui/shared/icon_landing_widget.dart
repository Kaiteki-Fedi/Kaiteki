import 'package:flutter/material.dart';

class IconLandingWidget extends StatelessWidget {
  final Widget icon;
  final Widget text;
  final double spacing;

  const IconLandingWidget({
    super.key,
    this.spacing = 6.0,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.disabledColor;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        DefaultTextStyle(
          style: TextStyle(color: color, fontSize: 72),
          child: IconTheme(
            data: IconThemeData(color: color, size: 72),
            child: icon,
          ),
        ),
        SizedBox(height: spacing),
        DefaultTextStyle(
          style: TextStyle(color: color),
          child: text,
        ),
      ],
    );
  }
}
