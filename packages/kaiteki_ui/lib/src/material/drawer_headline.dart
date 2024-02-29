import 'package:flutter/material.dart';

class DrawerHeadline extends StatelessWidget {
  final Widget text;

  const DrawerHeadline({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: SizedBox(
        height: 56,
        child: Align(
          alignment: Alignment.centerLeft,
          child: DefaultTextStyle.merge(
            style: theme.textTheme.titleSmall!.copyWith(
              color: theme.colorScheme.onSurface,
            ),
            child: text,
          ),
        ),
      ),
    );
  }
}
