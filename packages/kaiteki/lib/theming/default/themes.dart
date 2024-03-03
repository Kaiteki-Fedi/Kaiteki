import "package:flutter/material.dart";
import "package:kaiteki/theming/default/constants.dart";
import "package:kaiteki/theming/default/extensions.dart";
import "package:kaiteki/theming/themes.dart";
import "package:kaiteki_ui/kaiteki_ui.dart";

ThemeData makeDefaultTheme(Brightness brightness) =>
    makeTheme(AppTheme.affection.getColorScheme(brightness)!);

ThemeData makeTheme(ColorScheme colorScheme) {
  return ThemeData.from(colorScheme: colorScheme)
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
      appBarTheme: appBarTheme.copyWith(),
      snackBarTheme: snackBarTheme.copyWith(
        shape: const RoundedRectangleBorder(borderRadius: borderRadius),
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: dialogTheme.copyWith(shape: Shapes.large),
      bottomNavigationBarTheme: bottomNavigationBarTheme.copyWith(
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
      bottomSheetTheme: bottomSheetTheme.copyWith(
        showDragHandle: true,
      ),
    );
  }
}
