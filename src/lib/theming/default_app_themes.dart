import 'package:flutter/material.dart';
import 'package:kaiteki/app_colors.dart';

class DefaultAppThemes {
  static ColorScheme darkScheme = ColorScheme(
    background: AppColors.background,
    surface: AppColors.background,

    onPrimary: Colors.black,
    onSecondary: Colors.black,

    onBackground: Colors.white,
    onSurface: Colors.white,

    primary: AppColors.accent,
    primaryVariant: AppColors.accentVariant,

    error: Colors.red,
    onError: Colors.black,

    secondary: AppColors.accent,
    secondaryVariant: AppColors.accentVariant,

    brightness: Brightness.dark,
  );
}