import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:kaiteki/theming/default/constants.dart";
import "package:kaiteki/theming/default/extensions.dart";
import "package:kaiteki/theming/default/m2_color_schemes.dart" as m2;
import "package:kaiteki/theming/default/m3_color_schemes.dart" as m3;
import "package:kaiteki/theming/kaiteki/text_theme.dart";

ThemeData getDefaultTheme(Brightness brightness, bool useM3) {
  final colorScheme = getColorScheme(brightness, useM3);
  return ThemeData.from(colorScheme: colorScheme, useMaterial3: useM3)
      .addKaitekiExtensions()
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
    final navigationBarForegroundColor =
        colorScheme.brightness == Brightness.dark
            ? colorScheme.onSurface
            : colorScheme.onPrimary;
    return copyWith(
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.secondaryContainer,
        foregroundColor: colorScheme.onSecondaryContainer,
      ),
      snackBarTheme: const SnackBarThemeData(
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: const DialogTheme(
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.brightness == Brightness.dark
            ? colorScheme.surface
            : colorScheme.primary,
        selectedItemColor: navigationBarForegroundColor,
        unselectedItemColor: navigationBarForegroundColor.withOpacity(0.76),
        showSelectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
      textTheme: _createKaitekiTextTheme(textTheme, ktkTextTheme),
    );
  }
}

TextTheme _createKaitekiTextTheme(
  TextTheme original,
  KaitekiTextTheme? ktkTextTheme,
) {
  final baseTextTheme = GoogleFonts.robotoTextTheme(original);
  return baseTextTheme.copyWith(
    titleLarge: ktkTextTheme?.kaitekiTextStyle.copyWith(
      fontSize: baseTextTheme.titleLarge?.fontSize,
      color: baseTextTheme.titleLarge?.color,
    ),
  );
}
