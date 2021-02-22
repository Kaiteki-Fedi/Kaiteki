import 'package:fediverse_objects/pleroma/theme.dart';
import 'package:flutter/material.dart';
import 'package:kaiteki/theming/app_theme.dart';
import 'package:kaiteki/theming/pleroma/pleroma_theme_parser.dart';
import 'package:kaiteki/utils/utils.dart';

import '../../lib/theming/app_theme_source.dart';

class PleromaAppTheme implements AppThemeSource {
  final PleromaTheme _pleromaTheme;

  const PleromaAppTheme(this._pleromaTheme);

  BorderRadius getRadius(String key) {
    if (_pleromaTheme.radii.containsKey(key))
      return BorderRadius.circular(_pleromaTheme.radii[key]);

    return null;
  }

  @override
  AppTheme toTheme() {
    var colors = PleromaThemeParser.resolveColors(
        PleromaThemeParser.parseColors(_pleromaTheme.colors),
        _pleromaTheme.opacity);

    var themeData =
        ThemeData.from(colorScheme: _getColorScheme(colors)).copyWith(
      // buttons
      buttonTheme: ButtonThemeData(
        padding: EdgeInsets.symmetric(horizontal: 14),
        disabledColor: colors["btnDisabled"],
        buttonColor: colors["btn"],
        shape: RoundedRectangleBorder(borderRadius: getRadius("btn") ?? 8),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors["btn"],
        foregroundColor: colors["btnText"],
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: colors["selectedMenuIcon"],
        unselectedItemColor: colors["link"],
      ),
      appBarTheme: AppBarTheme(
        color: colors["topBar"],
        iconTheme: IconThemeData(color: colors["topBarLink"]),
        actionsIconTheme: IconThemeData(color: colors["topBarLink"]),
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: colors["input"],
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: getRadius("input") ?? 24,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 7, vertical: 8),
        isDense: true,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: colors["popover"],
        textStyle: TextStyle(
          color: colors["popoverText"],
        ),
      ),
    );

    return AppTheme(materialTheme: themeData);
  }

  ColorScheme _getColorScheme(Map<String, Color> colors) {
    var brightness = Utils.isLightBackground(colors["bg"])
        ? Brightness.light
        : Brightness.dark;

    return ColorScheme(
      background: colors["bg"],
      brightness: brightness,
      error: colors["cRed"],
      onBackground: colors["text"],
      onError: colors["alertErrorText"],
      onPrimary: colors["topBarText"],
      onSecondary: colors["fgText"],
      onSurface: colors["fgText"],
      primary: colors["topBar"],
      primaryVariant: colors["topBar"],
      secondary: colors["accent"],
      secondaryVariant: colors["accent"],
      surface: colors["fg"],
    );
  }
}
