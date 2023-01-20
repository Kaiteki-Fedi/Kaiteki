import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:kaiteki/preferences/app_experiment.dart";
import "package:notified_preferences/notified_preferences.dart";

class AppPreferences with NotifiedPreferences {
  late final locale =
      createSetting<String?>(key: "locale", initialValue: null).asProvider();

  late final experiments = createSetting<List<AppExperiment>>(
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
  ).asProvider();

  late final developerMode =
      createSetting<bool>(key: "dev", initialValue: false).asProvider();

  late final cwBehavior = createEnumSetting<ContentWarningBehavior>(
    key: "cwBehavior",
    initialValue: ContentWarningBehavior.automatic,
    values: ContentWarningBehavior.values,
  ).asProvider();
}

enum ContentWarningBehavior {
  // Post should always be collapsed
  collapse,
  // Post should be collapsed if it matches sensitive words
  automatic,
  // Post should always be expanded
  expanded,
}

extension PreferenceNotifierExtensions<T> on PreferenceNotifier<T> {
  ProviderBase<PreferenceNotifier<T>> asProvider() {
    return ChangeNotifierProvider<PreferenceNotifier<T>>((_) => this);
  }
}
