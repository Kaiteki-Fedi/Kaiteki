import 'package:flutter/material.dart';
import 'package:kaiteki/theming/default/extensions.dart';
import 'package:kaiteki/theming/default/m2_color_schemes.dart' as m2;
import 'package:kaiteki/theming/default/m3_color_schemes.dart' as m3;

ThemeData getTheme(Brightness brightness, bool useM3) {
  final ColorScheme colorScheme;

  if (brightness == Brightness.dark) {
    colorScheme = useM3 ? m3.darkColorScheme : m2.darkColorScheme;
  } else {
    colorScheme = useM3 ? m3.lightColorScheme : m2.lightColorScheme;
  }

  return ThemeData.from(
    colorScheme: colorScheme,
    useMaterial3: useM3,
  ).applyGeneralChanges();
}
