import "package:flutter/material.dart";
import "package:kaiteki/theming/default/constants.dart";
import "package:kaiteki/theming/default/extensions.dart";
import "package:kaiteki/theming/themes.dart";
import "package:kaiteki_ui/kaiteki_ui.dart";

ThemeData makeDefaultTheme(Brightness brightness, bool useMaterial3) {
  return makeTheme(
    AppTheme.affection.getColorScheme(brightness),
    useMaterial3,
  );
}

ThemeData makeTheme(
  ColorScheme colorScheme,
  bool useMaterial3,
) {
  final themeData = ThemeData.from(
    colorScheme: colorScheme,
    useMaterial3: useMaterial3,
  );
  return themeData //
      .addKaitekiTheme()
      .applyDefaultTweaks()
      .applyKaitekiTweaks();
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
