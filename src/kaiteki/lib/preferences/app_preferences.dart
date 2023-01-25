import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/app_experiment.dart";
import "package:kaiteki/preferences/content_warning_behavior.dart";
import "package:kaiteki/preferences/notified_preferences_riverpod.dart";

final locale = createSettingProvider<String?>(
  key: "locale",
  initialValue: null,
  provider: sharedPreferencesProvider,
);

final experiments = createSettingProvider<List<AppExperiment>>(
  key: "enabledExperiments",
  initialValue: const [],
  read: (prefs, key) {
    final list = prefs
        .getStringList(key)
        ?.map((v) => AppExperiment.values.firstWhere((e) => e.name == v))
        .toList();
    return list ?? const [];
  },
  write: (prefs, key, value) async {
    final list = value.map((e) => e.name).toList();
    await prefs.setStringList(key, list);
  },
  provider: sharedPreferencesProvider,
);

final developerMode = createSettingProvider<bool>(
  key: "dev",
  initialValue: false,
  provider: sharedPreferencesProvider,
);

final cwBehavior = createEnumSettingProvider<ContentWarningBehavior>(
  key: "cwBehavior",
  initialValue: ContentWarningBehavior.automatic,
  values: ContentWarningBehavior.values,
  provider: sharedPreferencesProvider,
);
