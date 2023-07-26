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
      floatingActionButtonTheme: floatingActionButtonTheme.copyWith(
        backgroundColor: useMaterial3 ? null : colorScheme.primary,
        foregroundColor: useMaterial3 ? null : colorScheme.onPrimary,
        extendedTextStyle: textTheme.labelLarge,
      ),
      cardTheme: cardTheme.copyWith(
        shadowColor: useMaterial3 ? Colors.transparent : null,
        margin: EdgeInsets.zero,
      ),
      menuButtonTheme: MenuButtonThemeData(
        style: (menuButtonTheme.style ?? const ButtonStyle()).copyWith(
          iconColor: useMaterial3
              ? null
              : MaterialStatePropertyAll(colorScheme.onSurface.withOpacity(.6)),
        ),
      ),
      appBarTheme: appBarTheme.copyWith(
        backgroundColor: useMaterial3 ? colorScheme.surface : null,
        foregroundColor: useMaterial3 ? colorScheme.onSurface : null,
        elevation: useMaterial3 ? 0.0 : null,
        scrolledUnderElevation: 4.0,
      ),
      snackBarTheme: snackBarTheme.copyWith(
        shape: const RoundedRectangleBorder(borderRadius: borderRadius),
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: dialogTheme.copyWith(
        shape: const RoundedRectangleBorder(borderRadius: borderRadius),
      ),
      bottomNavigationBarTheme: bottomNavigationBarTheme.copyWith(
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
      badgeTheme: useMaterial3
          ? null
          : badgeTheme.copyWith(
              backgroundColor: colorScheme.error,
              textColor: colorScheme.onError,
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
