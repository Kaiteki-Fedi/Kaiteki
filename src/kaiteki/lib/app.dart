import "package:dynamic_color/dynamic_color.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:kaiteki/constants.dart" as consts;
import "package:kaiteki/di.dart";
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
    final locale = ref.watch(preferencesProvider.select((p) => p.locale));
    final themePrefs = ref.watch(themeProvider);
    final router = ref.watch(routerProvider);
    final m3 = themePrefs.useMaterial3;
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        final useSystemScheme = themePrefs.useSystemColorScheme == true;

        final lightColorScheme = (useSystemScheme ? lightDynamic : null) ??
            getColorScheme(Brightness.light, m3);
        final lightTheme = ThemeData.from(
          colorScheme: lightColorScheme,
          useMaterial3: m3,
        ).applyDefaultTweaks().addKaitekiExtensions().applyKaitekiTweaks();

        final darkColorScheme = (useSystemScheme ? darkDynamic : null) ??
            getColorScheme(Brightness.dark, m3);
        final darkTheme = ThemeData.from(
          colorScheme: darkColorScheme,
          useMaterial3: m3,
        ).applyDefaultTweaks().addKaitekiExtensions().applyKaitekiTweaks();

        return MaterialApp.router(
          darkTheme: darkTheme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          routerConfig: router,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: _createLocale(locale),
          theme: lightTheme,
          themeMode: themePrefs.mode,
          title: consts.appName,
          shortcuts: shortcuts,
        );
      },
    );
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
