import 'package:flutter/material.dart';
import 'package:kaiteki/app_colors.dart';

class DefaultAppThemes {
  static ColorScheme lightScheme = ColorScheme(
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

  static ColorScheme darkScheme = ColorScheme(
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