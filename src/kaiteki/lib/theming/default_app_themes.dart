import 'package:flutter/material.dart';
import 'package:kaiteki/app_colors.dart';
import 'package:kaiteki/theming/material_app_theme.dart';

class DefaultAppThemes {
  static MaterialAppTheme lightAppTheme =
      MaterialAppTheme(ThemeData.from(colorScheme: lightScheme));
  static ColorScheme lightScheme = ColorScheme.light(
    background: AppColors.kaitekiGray.shade100,
    surface: AppColors.kaitekiGray.shade50,
    // primary
    primary: AppColors.kaitekiPink.shade500,
    primaryVariant: AppColors.kaitekiPink.shade700,
    onPrimary: Colors.white,
    // secondary
    secondary: AppColors.kaitekiOrange.shade400,
    secondaryVariant: AppColors.kaitekiOrange.shade600,
    onSecondary: Colors.black,
    // error
    error: Colors.red,
    onError: Colors.black,
  );

  static MaterialAppTheme darkAppTheme =
      MaterialAppTheme(ThemeData.from(colorScheme: darkScheme));
  static ColorScheme darkScheme = ColorScheme.dark(
    background: AppColors.kaitekiGray.shade900,
    surface: AppColors.kaitekiGray.shade800,
    // primary
    primary: AppColors.kaitekiPink.shade200,
    primaryVariant: AppColors.kaitekiPink.shade500,
    onPrimary: Colors.black,
    // secondary
    secondary: AppColors.kaitekiOrange.shade200,
    secondaryVariant: AppColors.kaitekiOrange.shade500,
    onSecondary: Colors.black,
    // error
    error: Colors.red,
    onError: Colors.black,
  );
}
