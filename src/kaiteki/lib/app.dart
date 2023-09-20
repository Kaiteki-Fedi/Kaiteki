import "package:dynamic_color/dynamic_color.dart";
import "package:flutter/material.dart";
import "package:kaiteki/constants.dart" as consts;
import "package:kaiteki/di.dart";
import "package:kaiteki/l10n/localizations.dart";
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
    final router = ref.watch(routerProvider);
    final locale = ref.watch(preferences.locale).value;

    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        final darkTheme =
            buildTheme(context, ref, Brightness.dark, darkDynamic);
        final lightTheme =
            buildTheme(context, ref, Brightness.light, lightDynamic);

        return MaterialApp.router(
          darkTheme: darkTheme,
          localizationsDelegates: KaitekiLocalizations.localizationsDelegates,
          routerConfig: router,
          supportedLocales: KaitekiLocalizations.supportedLocales,
          locale: createLocale(locale),
          theme: lightTheme,
          themeMode: themeMode,
          title: consts.kAppName,
          shortcuts: shortcuts,
        );
      },
    );
  }

  static ThemeData buildTheme(
    BuildContext context,
    WidgetRef ref,
    Brightness brightness,
    ColorScheme? systemColorScheme,
  ) {
    final useMaterial3 = ref.watch(preferences.useMaterial3).value;

    ColorScheme? colorScheme;
    if (ref.watch(preferences.useSystemColorScheme).value) {
      colorScheme = systemColorScheme;
    }

    colorScheme ??= getColorScheme(brightness, useMaterial3);

    final theme =
        ThemeData.from(colorScheme: colorScheme, useMaterial3: useMaterial3)
            .applyDefaultTweaks()
            .applyKaitekiTweaks()
            .applyUserPreferences(ref);

    return theme;
  }

  static Locale? createLocale(String? locale) {
    if (locale == null) return null;
    final split = locale.split("-");
    return Locale.fromSubtags(
      languageCode: split[0],
      scriptCode: split.length == 2 ? split[1] : null,
    );
  }
}
