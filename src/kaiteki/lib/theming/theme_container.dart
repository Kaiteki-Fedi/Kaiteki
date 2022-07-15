import 'package:flutter/material.dart';

/// A class that contains and handles theming.
class ThemeContainer extends ChangeNotifier {
  ThemeContainer(ThemeData initialTheme) : _current = initialTheme;

  late ThemeData _current;
  ThemeData get current => _current;
  set current(ThemeData source) {
    _current = source;
    notifyListeners();
  }
}
