import 'package:flutter/material.dart';
import 'package:kaiteki/ui/rounded_underline_tab_indicator.dart';

/// A widget that overrides the [TabBarTheme] for use on backgrounds with surface
/// color.
class PrimaryTabBarTheme extends StatelessWidget {
  final Widget child;

  const PrimaryTabBarTheme({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme.copyWith(
        tabBarTheme: TabBarTheme(
          indicator: RoundedUnderlineTabIndicator(
            borderSide: BorderSide(
              width: 2,
              color: Theme.of(context).colorScheme.primary,
            ),
            radius: const Radius.circular(2),
          ),
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Theme.of(context).disabledColor,
        ),
      ),
      child: child,
    );
  }
}
