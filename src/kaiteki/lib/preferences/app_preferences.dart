import "dart:collection";

import "package:flutter/material.dart";
import "package:kaiteki/preferences/app_experiment.dart";
import "package:shared_preferences/shared_preferences.dart";

const kLocale = "locale";
const kDev = "dev";
const kEnabledExperiments = "enabledExperiments";

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

  bool get developerMode => _preferences.getBool(kDev) ?? false;

  set developerMode(bool value) {
    if (developerMode == value) return;

    _preferences.setBool(kDev, value).then((_) => notifyListeners());
  }

  UnmodifiableSetView<AppExperiment> get enabledExperiments {
    final experimentsSet = _preferences
        .getStringList(kEnabledExperiments)
        ?.map((v) => AppExperiment.values.firstWhere((e) => e.name == v))
        .toSet();
    return UnmodifiableSetView(experimentsSet ?? const {});
  }

  ContentWarningBehavior get contentWarningBehavior {
    final value = _preferences.getString("cwBehavior");
    if (value == null) return ContentWarningBehavior.automatic;
    return ContentWarningBehavior.values.firstWhere((v) => v.name == value);
  }

  set contentWarningBehavior(ContentWarningBehavior value) {
    if (contentWarningBehavior == value) return;

    _preferences
        .setString("cwBehavior", value.name)
        .then((_) => notifyListeners());
  }

  Future<void> enableExperiment(AppExperiment experiment) async {
    if (enabledExperiments.contains(experiment)) return;
    final newSet = enabledExperiments.followedBy([experiment]);
    await _preferences.setStringList(
      kEnabledExperiments,
      newSet.map((e) => e.name).toList(),
    );
    notifyListeners();
  }

  Future<void> disableExperiment(AppExperiment experiment) async {
    if (!enabledExperiments.contains(experiment)) return;
    final filtered = enabledExperiments.where((e) => e != experiment);
    await _preferences.setStringList(
      kEnabledExperiments,
      filtered.map((e) => e.name).toList(),
    );
    notifyListeners();
  }

  AppPreferences(this._preferences);
}

enum ContentWarningBehavior {
  // Post should always be collapsed
  collapse,
  // Post should be collapsed if it matches sensitive words
  automatic,
  // Post should always be expanded
  expanded,
}
