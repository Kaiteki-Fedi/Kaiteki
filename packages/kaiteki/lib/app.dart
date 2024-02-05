import "package:dynamic_color/dynamic_color.dart";
import "package:flutter/material.dart";
import "package:kaiteki/constants.dart" as consts;
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/app_preferences.dart" as preferences;
import "package:kaiteki/preferences/theme_preferences.dart" as preferences;
import "package:kaiteki/routing/router.dart";
import "package:kaiteki/theming/default/extensions.dart";
import "package:kaiteki/theming/default/themes.dart";
import "package:kaiteki/theming/themes.dart";
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

    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        final darkTheme =
            buildTheme(context, ref, Brightness.dark, darkDynamic);
        final lightTheme =
            buildTheme(context, ref, Brightness.light, lightDynamic);

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
            localizationsDelegates: KaitekiLocalizations.localizationsDelegates,
            routerConfig: ref.watch(routerProvider),
            supportedLocales: KaitekiLocalizations.supportedLocales,
            // FIXME(Craftplacer): `kab` results in no MaterialLocalizations
            locale: locale != const Locale("kab") ? locale : null,
            theme: lightTheme,
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
    );
  }

  static ThemeData buildTheme(
    BuildContext context,
    WidgetRef ref,
    Brightness brightness,
    ColorScheme? systemColorScheme,
  ) {
    ColorScheme getColorScheme() {
      final useHighContrast = ref.watch(preferences.useHighContrast).value;

      if (useHighContrast) {
        // TODO(Craftplacer): Implement high contrast themes
      }

      final appTheme = ref.watch(preferences.theme).value;

      return appTheme.getColorScheme(brightness) ??
          systemColorScheme ??
          AppTheme.affection.getColorScheme(brightness)!;
    }

    return ThemeData.from(colorScheme: getColorScheme())
        .applyDefaultTweaks()
        .applyKaitekiTweaks()
        .applyUserPreferences(ref);
  }
}
