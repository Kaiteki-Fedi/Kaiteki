import 'package:flutter/material.dart';
import 'package:kaiteki/utils/extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';

const kLocale = "locale";

class AppPreferences extends ChangeNotifier {
  final SharedPreferences _preferences;

  String? get locale => _preferences.getString(kLocale);

  set locale(String? locale) {
    if (this.locale == locale) return;

    if (locale == null) {
      _preferences.remove(kLocale).then((_) => notifyListeners());
    } else {
      _preferences.setString(kLocale, locale).then((_) => notifyListeners());
    }
  }

  AppPreferences(this._preferences);
}
