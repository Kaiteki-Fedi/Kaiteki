import 'package:flutter/material.dart';
import 'package:kaiteki/api/model/pleroma/theme.dart';

class ThemeContainer extends ChangeNotifier {
  // ThemeData _current;
  ThemeData _initial;
  PleromaTheme _currentPleroma;

  double _backgroundOpacity = 1.0;

  double get backgroundOpacity => _backgroundOpacity;
  set backgroundOpacity(double value) {
    _backgroundOpacity = value;
    notifyListeners();
  }

  ThemeData getCurrentTheme() {
    var materialTheme = _initial;

    var pleroma = getCurrentPleromaTheme();
    if (pleroma != null)
      materialTheme = pleroma.toMaterialTheme();

    if (backgroundOpacity < 1.0)
      materialTheme = materialTheme.copyWith(
        scaffoldBackgroundColor: Colors.transparent,
        backgroundColor: Colors.transparent,
      );

    return materialTheme;
  }
  PleromaTheme getCurrentPleromaTheme() => _currentPleroma;

  ThemeContainer(ThemeData initialTheme) {
    _initial = initialTheme;
  }

  // void changeTheme(ThemeData theme) {
  //   _current = theme;
  //   notifyListeners();
  // }

  void changePleromaTheme(PleromaTheme pleromaTheme) {
    _currentPleroma = pleromaTheme;
    notifyListeners();
  }

  bool get hasBackground => _background != null;

  ImageProvider _background;

  ImageProvider getBackground() => _background;

  void setBackground(ImageProvider image) {
    _background = image;
    notifyListeners();
  }
}