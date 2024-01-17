import "dart:ui" show Locale;

import "package:collection/collection.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/model/auth/account_key.dart";
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
      return prefs.getString(key).andThen(parseLocale);
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

final showFavoriteCounts = createSettingProvider<bool>(
  key: "showFavoriteCounts",
  initialValue: true,
  provider: sharedPreferencesProvider,
);

final showReplyCounts = createSettingProvider<bool>(
  key: "showReplyCounts",
  initialValue: true,
  provider: sharedPreferencesProvider,
);

final showRepeatCounts = createSettingProvider<bool>(
  key: "showRepeatCounts",
  initialValue: true,
  provider: sharedPreferencesProvider,
);

final showReactions = createSettingProvider<bool>(
  key: "showReactions",
  initialValue: true,
  provider: sharedPreferencesProvider,
);

final showReactionCounts = createSettingProvider<bool>(
  key: "showReactionCounts",
  initialValue: true,
  provider: sharedPreferencesProvider,
);

final showAttachmentDescriptionWarning = createSettingProvider<bool>(
  key: "showAttachmentDescriptionWarning",
  initialValue: false,
  provider: sharedPreferencesProvider,
);

final readDisplayNameOnly = createSettingProvider<bool>(
  key: "readDisplayNameOnly",
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

final lastUsedAccount = createSettingProvider<AccountKey?>(
  key: "lastUsedAccount",
  provider: sharedPreferencesProvider,
  read: (prefs, key) {
    final value = prefs.getString(key);
    if (value == null) return null;
    return AccountKey.fromUri(value);
  },
  write: (prefs, key, value) async {
    if (value == null) {
      await prefs.remove(key);
    } else {
      await prefs.setString(key, value.toUri().toString());
    }
  },
  initialValue: null,
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

final useHighContrast = createSettingProvider<bool>(
  key: "useHighContrast",
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

final postTextSize = createSettingProvider<double>(
  key: "postTextSize",
  initialValue: 1.0,
  provider: sharedPreferencesProvider,
);

final hasFinishedOnboarding = createSettingProvider<bool>(
  key: "hasFinishedOnboarding",
  initialValue: false,
  provider: sharedPreferencesProvider,
);

final showAds = createSettingProvider<bool>(
  key: "showAds",
  initialValue: true,
  provider: sharedPreferencesProvider,
);

final linkWarningPolicy = createEnumSettingProvider<LinkWarningPolicy>(
  key: "linkWarningPolicy",
  initialValue: LinkWarningPolicy.onAds,
  values: LinkWarningPolicy.values,
  provider: sharedPreferencesProvider,
);

enum LinkWarningPolicy { always, onAds, never }
