import 'package:flutter/material.dart';

// TODO(Craftplacer): Provide defaults of widgets being used (Icon, Text) and give the user flexibility of using other widgets.
class IconLandingWidget extends StatelessWidget {
  final Icon icon;
  final Text text;
  final double spacing;

  const IconLandingWidget({
    Key? key,
    this.spacing = 6.0,
    required this.icon,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.dividerColor;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        IconTheme(
          data: IconThemeData(color: color, size: 72),
          child: icon,
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
