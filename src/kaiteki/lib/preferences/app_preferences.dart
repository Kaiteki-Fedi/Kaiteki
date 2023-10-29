import "dart:ui" show Locale;

import "package:collection/collection.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/app_experiment.dart";
import "package:kaiteki/preferences/content_warning_behavior.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/utils.dart";
import "package:logging/logging.dart";
import "package:notified_preferences_riverpod/notified_preferences_riverpod.dart";

enum InterfaceFont {
  system,
  roboto,
  kaiteki,
  openDyslexic,
  atkinsonHyperlegible,
}

final locale = createSettingProvider<Locale?>(
  key: "locale",
  initialValue: null,
  provider: sharedPreferencesProvider,
  read: (prefs, key) {
    try {
      return prefs.getString(key).nullTransform(parseLocale);
    } catch (e, s) {
      Logger("locale").warning(
        "Failed to parse locale, is this using a deprecated format?",
        e,
        s,
      );
      return null;
    }
  },
  write: (prefs, key, value) async {
    if (value == null) {
      await prefs.remove(key);
    } else {
      await prefs.setString(key, value.toLanguageTag());
    }
  },
);

final experiments = createSettingProvider<List<AppExperiment>>(
  key: "enabledExperiments",
  initialValue: const [],
  read: (prefs, key) {
    final list = prefs
        .getStringList(key)
        ?.map((v) => AppExperiment.values.firstWhereOrNull((e) => e.name == v))
        .whereNotNull()
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
  initialValue: ContentWarningBehavior.collapse,
  values: ContentWarningBehavior.values,
  provider: sharedPreferencesProvider,
);

final hidePostMetrics = createSettingProvider<bool>(
  key: "hidePostMetrics",
  initialValue: false,
  provider: sharedPreferencesProvider,
);

final showAttachmentDescriptionWarning = createSettingProvider<bool>(
  key: "showAttachmentDescriptionWarning",
  initialValue: false,
  provider: sharedPreferencesProvider,
);

final showDedicatedPostOpenButton = createSettingProvider<bool>(
  key: "showDedicatedPostOpenButton",
  initialValue: false,
  provider: sharedPreferencesProvider,
);

final recentlyUsedEmojis = createSettingProvider<List<String>>(
  key: "recentlyUsedEmojis",
  initialValue: const [],
  provider: sharedPreferencesProvider,
);

final visibleLanguages = createSettingProvider<ISet<String>>(
  key: "visibleLanguages",
  initialValue: ISet(const {}),
  read: (prefs, key) {
    final list = prefs.getStringList(key);
    if (list == null) return null;
    return ISet(list);
  },
  write: (prefs, key, value) async {
    await prefs.setStringList(key, value.toList());
  },
  provider: sharedPreferencesProvider,
);

final coloredPostVisibilities = createSettingProvider<bool>(
  key: "coloredPostVisibilities",
  initialValue: false,
  provider: sharedPreferencesProvider,
);

final underlineLinks = createSettingProvider<bool>(
  key: "underlineLinks",
  initialValue: false,
  provider: sharedPreferencesProvider,
);

final interfaceFont = createEnumSettingProvider<InterfaceFont>(
  key: "interfaceFont",
  initialValue: InterfaceFont.kaiteki,
  values: InterfaceFont.values,
  provider: sharedPreferencesProvider,
);
