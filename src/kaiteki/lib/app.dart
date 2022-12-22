import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kaiteki/constants.dart' as consts;
import 'package:kaiteki/di.dart';
import 'package:kaiteki/routing/router.dart';
import 'package:kaiteki/theming/default/themes.dart';
import 'package:kaiteki/ui/shortcuts/shortcuts.dart';

class KaitekiApp extends ConsumerWidget {
  const KaitekiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(preferencesProvider.select((p) => p.locale));
    final themePrefs = ref.watch(themeProvider);
    final router = ref.watch(routerProvider);
    final m3 = themePrefs.useMaterial3 ?? themePrefs.material3Default;
    return MaterialApp.router(
      darkTheme: getTheme(Brightness.dark, m3),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routerConfig: router,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale == null ? null : Locale(locale),
      theme: getTheme(Brightness.light, m3),
      themeMode: themePrefs.mode,
      title: consts.appName,
      shortcuts: shortcuts,
    );
  }
}
