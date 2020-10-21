import 'package:flutter/material.dart';
import 'package:kaiteki/app_colors.dart';

import 'package:kaiteki/theming/app_theme.dart';

import 'package:kaiteki/theming/material_app_theme.dart';

class DefaultAppThemes {
  static MaterialAppTheme lightAppTheme = MaterialAppTheme(ThemeData.from(colorScheme: lightScheme));
  static MaterialAppTheme darkAppTheme = MaterialAppTheme(ThemeData.from(colorScheme: darkScheme));

  static ColorScheme lightScheme = ColorScheme.light(
    background: AppColors.lightBackground,
    surface: AppColors.lightSurface,

    onPrimary: Colors.black,
    onSecondary: Colors.black,

    onBackground: Colors.black,
    onSurface: Colors.black,

    primary: AppColors.kaitekiPink.shade400,
    primaryVariant: AppColors.kaitekiPink.shade600,

    error: Colors.red,
    onError: Colors.black,

    secondary: AppColors.kaitekiPink.shade400,
    secondaryVariant: AppColors.kaitekiPink.shade600,

    brightness: Brightness.light,
  );

  static ColorScheme darkScheme = ColorScheme.dark(
    background: AppColors.darkBackground,
    surface: AppColors.darkBackground,

    onPrimary: Colors.black,
    onSecondary: Colors.black,

    onBackground: Colors.white,
    onSurface: Colors.white,

    primary: AppColors.kaitekiPink.shade200,
    primaryVariant: AppColors.kaitekiPink.shade500,

    error: Colors.red,
    onError: Colors.black,

    secondary: AppColors.kaitekiPink.shade200,
    secondaryVariant: AppColors.kaitekiPink.shade500,

    brightness: Brightness.dark,
  );
}