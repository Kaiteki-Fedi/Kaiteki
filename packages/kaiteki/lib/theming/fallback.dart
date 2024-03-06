import "package:flutter/material.dart";
import "package:kaiteki/theming/accent.dart";

final _fallbackColorScheme =
    AppAccent.affection.getColorScheme(Brightness.light)!;
final _fallbackDarkColorScheme =
    AppAccent.affection.getColorScheme(Brightness.dark)!;

final fallbackTheme = ThemeData.from(colorScheme: _fallbackColorScheme);

final fallbackDarkTheme = ThemeData.from(colorScheme: _fallbackDarkColorScheme);
