import "package:flutter/material.dart";
import "package:kaiteki/theming/default/constants.dart";
import "package:kaiteki/theming/default/extensions.dart";
import "package:kaiteki/theming/default/m2_color_schemes.dart" as m2;
import "package:kaiteki/theming/default/m3_color_schemes.dart" as m3;
import "package:kaiteki_ui/kaiteki_ui.dart";

ThemeData getDefaultTheme(Brightness brightness, bool useM3) {
  final colorScheme = getColorScheme(brightness, useM3);
  return ThemeData.from(colorScheme: colorScheme, useMaterial3: useM3)
      .addKaitekiTheme()
      .applyDefaultTweaks()
      .applyKaitekiTweaks();
}

ColorScheme getColorScheme(Brightness brightness, bool useM3) {
  if (brightness == Brightness.dark) {
    return useM3 ? m3.darkColorScheme : m2.darkColorScheme;
  } else {
    return useM3 ? m3.lightColorScheme : m2.lightColorScheme;
  }
}

extension ThemeDataExtensions on ThemeData {
  ThemeData applyKaitekiTweaks() {
    return copyWith(
      floatingActionButtonTheme: floatingActionButtonTheme.copyWith(
        extendedTextStyle: textTheme.labelLarge,
      ),
      cardTheme: cardTheme.copyWith(
        shadowColor: useMaterial3 ? Colors.transparent : null,
        margin: EdgeInsets.zero,
      ),
      appBarTheme: appBarTheme.copyWith(),
      snackBarTheme: snackBarTheme.copyWith(
        shape: const RoundedRectangleBorder(borderRadius: borderRadius),
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme:
          useMaterial3 ? dialogTheme.copyWith(shape: Shapes.large) : null,
      bottomNavigationBarTheme: bottomNavigationBarTheme.copyWith(
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
