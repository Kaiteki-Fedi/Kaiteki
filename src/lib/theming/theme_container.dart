import 'package:flutter/material.dart';
import 'package:kaiteki/theming/pleroma_theme.dart';

class ThemeContainer extends ChangeNotifier {
  // ThemeData _current;
  ThemeData _initial;
  PleromaTheme _currentPleroma;


  ThemeData getCurrentTheme() {
    var pleroma = getCurrentPleromaTheme();

    if (pleroma != null)
      return pleroma.toMaterialTheme();

    return _initial;
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