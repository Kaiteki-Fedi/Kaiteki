import 'package:flutter/material.dart';
import 'package:kaiteki/theming/app_themes/app_theme.dart';
import 'package:kaiteki/theming/app_theme_source.dart';

/// A class that contains and handles theming.
class ThemeContainer extends ChangeNotifier {
  ThemeContainer(AppThemeSource initialTheme) {
    source = initialTheme;
  }

  AppThemeSource _source;
  AppThemeSource get source => _source;
  set source(AppThemeSource source) {
    assert(source != null);

    _source = source;
    notifyListeners();
  }

  AppTheme get current => _source.toTheme();

  ThemeData getMaterialTheme() {
    var theme = current.materialTheme;

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

  bool get hasBackground => _background != null;
  ImageProvider _background;
  ImageProvider get background => _background;
  set background(ImageProvider image) {
    _background = image;
    notifyListeners();
  }
}
