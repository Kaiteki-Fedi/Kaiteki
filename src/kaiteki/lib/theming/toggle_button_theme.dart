import 'package:flutter/material.dart';

class ToggleButtonTheme {
  final Color activeBackground;
  final Color inactiveBackground;
  final TextStyle activeTextStyle;
  final TextStyle inactiveTextStyle;

  const ToggleButtonTheme({
    required this.activeBackground,
    required this.inactiveBackground,
    required this.activeTextStyle,
    required this.inactiveTextStyle,
  });

  ToggleButtonTheme.from(ThemeData materialTheme)
      : inactiveBackground = materialTheme.colorScheme.surface,
        activeBackground = materialTheme.colorScheme.secondary,
        inactiveTextStyle =
            TextStyle(color: materialTheme.colorScheme.onSurface),
        activeTextStyle = TextStyle(color: materialTheme.colorScheme.secondary);
}
