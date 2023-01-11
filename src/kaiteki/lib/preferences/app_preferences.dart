import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:kaiteki/preferences/app_experiment.dart';
import 'package:kaiteki/utils/extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';

const kLocale = "locale";
const kDev = "dev";
const kEnabledExperiments = "enabledExperiments";
const kCheckedForUpdatesAt = "checkedForUpdatesAt";
const kCheckForUpdates = "checkForUpdates";

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

  DateTime? get checkedForUpdatesAt {
    final value = _preferences.getString(kCheckedForUpdatesAt);
    return value.nullTransform(DateTime.parse);
  }

  set checkedForUpdatesAt(DateTime? value) {
    assert(value != null);
    _preferences.setString(
      kCheckedForUpdatesAt,
      value!.toIso8601String(),
    );
  }

  bool get checkForUpdates => _preferences.getBool(kCheckForUpdates) ?? false;

  set checkForUpdates(bool value) {
    _preferences.setBool(kCheckForUpdates, value);
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
