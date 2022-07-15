import 'package:flutter/material.dart';

class DialogTitleWithHero extends StatelessWidget {
  final Widget icon;
  final Widget title;

  const DialogTitleWithHero({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final heroIconColor = theme.useMaterial3 //
        ? theme.colorScheme.secondary
        : theme.disabledColor;
    return Column(
      children: [
        IconTheme(
          data: IconThemeData(color: heroIconColor),
          child: icon,
        ),
        const SizedBox(height: 16),
        DefaultTextStyle.merge(
          textAlign: TextAlign.center,
          child: title,
        ),
      ],
    );
  }
}
