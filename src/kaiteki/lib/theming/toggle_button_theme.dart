import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

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
      : inactiveBackground = materialTheme.cardColor,
        activeBackground = materialTheme.accentColor,
        inactiveTextStyle = materialTheme.textTheme.bodyText1!,
        activeTextStyle = materialTheme.accentTextTheme.bodyText1!;
}
