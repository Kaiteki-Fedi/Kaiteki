import "package:dynamic_color/dynamic_color.dart";
import "package:flutter/material.dart";
import "package:kaiteki/constants.dart" as consts;
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/app_preferences.dart" as preferences;
import "package:kaiteki/preferences/theme_preferences.dart" as preferences;
import "package:kaiteki/routing/router.dart";
import "package:kaiteki/theming/accent.dart";
import "package:kaiteki/theming/default/extensions.dart";
import "package:kaiteki/theming/default/theme.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki/ui/shortcuts/intents.dart";
import "package:kaiteki/ui/shortcuts/shortcuts.dart";
import "package:kaiteki_l10n/kaiteki_l10n.dart";

final _debugShowCheckedModeBannerProvider = StateProvider((_) => true);
final _debugShowMaterialGridProvider = StateProvider((_) => false);
final _showPerformanceOverlayProvider = StateProvider((_) => false);
final _checkerboardRasterCacheImagesProvider = StateProvider((_) => false);
final _checkerboardOffscreenLayersProvider = StateProvider((_) => false);
final _showSemanticsDebuggerProvider = StateProvider((_) => false);

final class KaitekiApp extends ConsumerWidget {
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
    final locale = ref.watch(preferences.locale).value;

    // debug flags
    final debugShowCheckedModeBanner =
        ref.watch(_debugShowCheckedModeBannerProvider);
    final debugShowMaterialGrid = ref.watch(_debugShowMaterialGridProvider);
    final showPerformanceOverlay = ref.watch(_showPerformanceOverlayProvider);
    final checkerboardRasterCacheImages =
        ref.watch(_checkerboardRasterCacheImagesProvider);
    final checkerboardOffscreenLayers =
        ref.watch(_checkerboardOffscreenLayersProvider);
    final showSemanticsDebugger = ref.watch(_showSemanticsDebuggerProvider);

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        highContrast:
            ref.watch(preferences.useHighContrast).value ? true : null,
      ),
      child: DynamicColorBuilder(
        builder: (lightDynamic, darkDynamic) {
          final interfaceFont = ref.watch(preferences.interfaceFont).value;
          final textTheme = getTextTheme(const TextTheme(), interfaceFont);

          final (
            :theme,
            :darkTheme,
            :highContrastTheme,
            :highContrastDarkTheme
          ) = getThemes(
            ref,
            ref.watch(preferences.theme).value,
            textTheme,
            lightDynamic,
            darkDynamic,
          );

          return ProviderScope(
            overrides: [
              systemColorSchemeProvider.overrideWithValue(
                darkDynamic == null || lightDynamic == null
                    ? null
                    : (dark: darkDynamic, light: lightDynamic),
              ),
            ],
            child: MaterialApp.router(
              darkTheme: darkTheme,
              localizationsDelegates:
                  KaitekiLocalizations.localizationsDelegates,
              routerConfig: ref.watch(routerProvider),
              supportedLocales: KaitekiLocalizations.supportedLocales,
              // FIXME(Craftplacer): `kab` results in no MaterialLocalizations
              locale: locale != const Locale("kab") ? locale : null,
              theme: theme,
              highContrastTheme: highContrastTheme,
              highContrastDarkTheme: highContrastDarkTheme,
              themeMode: themeMode,
              title: consts.kAppName,
              shortcuts: {
                ...WidgetsApp.defaultShortcuts,
                ...shortcuts,
              },
              debugShowMaterialGrid: debugShowMaterialGrid,
              debugShowCheckedModeBanner: debugShowCheckedModeBanner,
              showPerformanceOverlay: showPerformanceOverlay,
              checkerboardRasterCacheImages: checkerboardRasterCacheImages,
              checkerboardOffscreenLayers: checkerboardOffscreenLayers,
              showSemanticsDebugger: showSemanticsDebugger,
              actions: {
                ...WidgetsApp.defaultActions,
                ToggleDebugFlagIntent: CallbackAction<ToggleDebugFlagIntent>(
                  onInvoke: (intent) {
                    final provider = switch (intent.flag) {
                      DebugFlag.debugShowMaterialGrid =>
                        _debugShowMaterialGridProvider,
                      DebugFlag.showPerformanceOverlay =>
                        _showPerformanceOverlayProvider,
                      DebugFlag.checkerboardRasterCacheImages =>
                        _checkerboardRasterCacheImagesProvider,
                      DebugFlag.checkerboardOffscreenLayers =>
                        _checkerboardOffscreenLayersProvider,
                      DebugFlag.showSemanticsDebugger =>
                        _showSemanticsDebuggerProvider,
                      DebugFlag.debugShowCheckedModeBanner =>
                        _debugShowCheckedModeBannerProvider,
                    };

                    ref.read(provider.notifier).state = !ref.read(provider);
                    return null;
                  },
                ),
              },
            ),
          );
        },
      ),
    );
  }

  static ThemeSet getThemes(
    WidgetRef ref,
    AppAccent? accent,
    TextTheme textTheme,
    ColorScheme? systemLightColorScheme,
    ColorScheme? systemDarkColorScheme,
  ) {
    ThemeData light, dark, highContrastLight, highContrastDark;

    ColorScheme getColorScheme(Brightness brightness) {
      ColorScheme? colorScheme;

      if (accent == null) {
        colorScheme = switch (brightness) {
          Brightness.light => systemLightColorScheme,
          Brightness.dark => systemDarkColorScheme,
        };
      }

      return colorScheme ??
          accent?.getColorScheme(brightness) ??
          AppAccent.affection.getColorScheme(brightness)!;
    }

    highContrastLight = MaterialTheme(textTheme).lightHighContrast();
    highContrastDark = MaterialTheme(textTheme).darkHighContrast();

    if (accent == AppAccent.affection) {
      light = MaterialTheme(textTheme).light();
      dark = MaterialTheme(textTheme).dark();
    } else {
      light = ThemeData.from(
        colorScheme: getColorScheme(Brightness.light),
        textTheme: textTheme,
      );
      dark = ThemeData.from(
        colorScheme: getColorScheme(Brightness.dark),
        textTheme: textTheme,
      );
    }

    return (
      theme: light.applyTweaks().applyUserPreferences(ref),
      darkTheme: dark.applyTweaks().applyUserPreferences(ref),
      highContrastTheme:
          highContrastLight.applyTweaks().applyUserPreferences(ref),
      highContrastDarkTheme:
          highContrastDark.applyTweaks().applyUserPreferences(ref),
    );
  }

  static TextTheme getTextTheme(
    TextTheme? original,
    preferences.InterfaceFont font,
  ) {
    final textTheme = original ?? const TextTheme();
    return switch (font) {
      preferences.InterfaceFont.system => textTheme,
      preferences.InterfaceFont.roboto => textTheme.apply(fontFamily: "Roboto"),
      preferences.InterfaceFont.kaiteki =>
        textTheme.apply(fontFamily: "Fira Sans"),
      preferences.InterfaceFont.atkinsonHyperlegible =>
        textTheme.apply(fontFamily: "Aktkinson Hyperlegible"),
      preferences.InterfaceFont.openDyslexic =>
        textTheme.apply(fontFamily: "OpenDyslexic"),
    };
  }
}
