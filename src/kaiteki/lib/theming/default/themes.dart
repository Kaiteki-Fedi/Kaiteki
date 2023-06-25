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
    return copyWith(
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: useMaterial3 ? null : colorScheme.primary,
        foregroundColor: useMaterial3 ? null : colorScheme.onPrimary,
        extendedTextStyle: textTheme.labelLarge,
      ),
      cardTheme: CardTheme(
        shadowColor: useMaterial3 ? Colors.transparent : null,
        margin: EdgeInsets.zero,
      ),
      menuButtonTheme: MenuButtonThemeData(
        style: MenuItemButton.styleFrom(
          iconColor:
              useMaterial3 ? null : colorScheme.onSurface.withOpacity(.6),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: useMaterial3 ? 0.0 : null,
        scrolledUnderElevation: 4.0,
      ),
      snackBarTheme: const SnackBarThemeData(
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: const DialogTheme(
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
      badgeTheme: BadgeThemeData(
        backgroundColor: useMaterial3 ? null : colorScheme.error,
        textColor: useMaterial3 ? null : colorScheme.onError,
      ),
      textTheme: _createKaitekiTextTheme(textTheme, ktkTextTheme),
    );
  }
}

TextTheme _createKaitekiTextTheme(
  TextTheme original,
  KaitekiTextTheme? ktkTextTheme,
) {
  final baseTextTheme = GoogleFonts.firaSansTextTheme(original);
  return baseTextTheme.copyWith(
    titleLarge: ktkTextTheme?.kaitekiTextStyle,
  );
}
