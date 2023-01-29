import "package:dynamic_color/dynamic_color.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:kaiteki/constants.dart" as consts;
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/app_preferences.dart" as preferences;
import "package:kaiteki/preferences/theme_preferences.dart" as preferences;
import "package:kaiteki/routing/router.dart";
import "package:kaiteki/theming/default/extensions.dart";
import "package:kaiteki/theming/default/themes.dart";
import "package:kaiteki/ui/shortcuts/shortcuts.dart";

class KaitekiApp extends ConsumerWidget {
  const KaitekiApp({super.key});

  static const versionCode = bool.hasEnvironment("VERSION_CODE")
      ? String.fromEnvironment("VERSION_CODE")
      : null;

  static const versionName = bool.hasEnvironment("VERSION_NAME")
      ? String.fromEnvironment("VERSION_NAME")
      : null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(preferences.themeMode).value;
    final useMaterial3 = ref.watch(preferences.useMaterial3).value;
    final useSystemColorScheme =
        ref.watch(preferences.useSystemColorScheme).value;
    final useNaturalBadgeColors =
        ref.watch(preferences.useNaturalBadgeColors).value;
    final router = ref.watch(routerProvider);
    final locale = ref.watch(preferences.locale).value;

    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        final darkTheme = _createTheme(
          Brightness.dark,
          darkDynamic,
          useSystemScheme: useSystemColorScheme,
          useMaterial3: useMaterial3,
          useNaturalBadgeColors: useNaturalBadgeColors,
        );

        final lightTheme = _createTheme(
          Brightness.light,
          lightDynamic,
          useSystemScheme: useSystemColorScheme,
          useMaterial3: useMaterial3,
          useNaturalBadgeColors: useNaturalBadgeColors,
        );

        return MaterialApp.router(
          darkTheme: darkTheme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          routerConfig: router,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: _createLocale(locale),
          theme: lightTheme,
          themeMode: themeMode,
          title: consts.appName,
          shortcuts: shortcuts,
        );
      },
    );
  }

  ThemeData _createTheme(
    Brightness brightness,
    ColorScheme? systemColorScheme, {
    required bool useSystemScheme,
    required bool useMaterial3,
    required bool useNaturalBadgeColors,
  }) {
    ColorScheme? colorScheme;

    if (useSystemScheme) colorScheme = systemColorScheme;

    colorScheme ??= getColorScheme(brightness, useMaterial3);

    final theme =
        ThemeData.from(colorScheme: colorScheme, useMaterial3: useMaterial3)
            .applyDefaultTweaks(useNaturalBadgeColors: useNaturalBadgeColors)
            .addKaitekiExtensions()
            .applyKaitekiTweaks();

    return theme;
  }

  Locale? _createLocale(String? locale) {
    if (locale == null) return null;
    final split = locale.split("-");
    return Locale.fromSubtags(
      languageCode: split[0],
      scriptCode: split.length == 2 ? split[1] : null,
    );
  }
}
