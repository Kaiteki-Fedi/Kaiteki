import 'package:flutter/material.dart';
import 'package:kaiteki/theming/default/extensions.dart';
import 'package:kaiteki/theming/default/m2_color_schemes.dart' as m2;
import 'package:kaiteki/theming/default/m3_color_schemes.dart' as m3;

ThemeData getDefaultTheme(Brightness brightness, bool useM3) {
  return ThemeData.from(
    colorScheme: getColorScheme(brightness, useM3),
    useMaterial3: useM3,
  ).applyGeneralChanges();
}

ColorScheme getColorScheme(Brightness brightness, bool useM3) {
  if (brightness == Brightness.dark) {
    return useM3 ? m3.darkColorScheme : m2.darkColorScheme;
  } else {
    return useM3 ? m3.lightColorScheme : m2.lightColorScheme;
  }
}
