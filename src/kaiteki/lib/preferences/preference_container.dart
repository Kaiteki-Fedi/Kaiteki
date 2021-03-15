import 'package:flutter/foundation.dart';
import 'package:kaiteki/preferences/app_preferences.dart';

/// A class that wraps around app settings and provides tracking of updates.
class PreferenceContainer extends ChangeNotifier {
  AppPreferences _preferences;

  PreferenceContainer(this._preferences);

  void update(Function(AppPreferences preferences) updateCallback) {
    updateCallback(_preferences);
    notifyListeners();
  }

  AppPreferences get() => _preferences;
}
