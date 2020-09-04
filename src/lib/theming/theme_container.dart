import 'package:flutter/material.dart';
import 'package:kaiteki/theming/app_theme.dart';
import 'package:kaiteki/theming/app_theme_convertible.dart';

/// A class that contains and handles theming.
class ThemeContainer extends ChangeNotifier {
  AppThemeConvertible _appTheme;
  AppThemeConvertible get rawTheme => _appTheme;
  set rawTheme(AppThemeConvertible theme) {
    _appTheme = theme;
    notifyListeners();
  }

  AppTheme get currentTheme => _appTheme.toTheme();
  ThemeData get materialTheme {
    var theme = currentTheme.materialTheme;

    // adjust theme for user preference of transparent backgrounds
    if (backgroundOpacity < 1.0)
      theme = theme.copyWith(
        scaffoldBackgroundColor: Colors.transparent,
        backgroundColor: Colors.transparent,
      );

    return theme;
  }

  double _backgroundOpacity = 1.0;
  double get backgroundOpacity => _backgroundOpacity;
  set backgroundOpacity(double value) {
    _backgroundOpacity = value;
    notifyListeners();
  }

  ThemeContainer(AppThemeConvertible initialTheme) {
    rawTheme = initialTheme;
  }

  bool get hasBackground => _background != null;
  ImageProvider _background;
  ImageProvider get background => _background;
  set background(ImageProvider image) {
    _background = image;
    notifyListeners();
  }
}