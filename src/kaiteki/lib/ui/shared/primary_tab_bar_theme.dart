import 'package:flutter/material.dart';
import 'package:kaiteki/ui/rounded_underline_tab_indicator.dart';

/// A widget that overrides the [TabBarTheme] for use on backgrounds with surface
/// color.
class AppBarTabBarTheme extends StatelessWidget {
  final Widget child;

  const AppBarTabBarTheme({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (theme.useMaterial3) return child;

    return Theme(
      data: theme.copyWith(
        tabBarTheme: TabBarTheme(
          indicator: RoundedUnderlineTabIndicator(
            borderSide: BorderSide(
              width: 3,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          labelColor: theme.colorScheme.onPrimary,
          unselectedLabelColor: theme.colorScheme.onPrimaryContainer,
        ),
      ),
      child: child,
    );
  }
}
