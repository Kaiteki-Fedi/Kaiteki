import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kaiteki/constants.dart' as consts;
import 'package:kaiteki/di.dart';
import 'package:kaiteki/routes.dart';
import 'package:kaiteki/theming/default/themes.dart';
import 'package:kaiteki/ui/shortcuts/shortcuts.dart';

class KaitekiApp extends ConsumerWidget {
  const KaitekiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themePrefs = ref.watch(themeProvider);
    final m3 = themePrefs.useMaterial3 ?? themePrefs.material3Default;
    return MaterialApp.router(
      darkTheme: getTheme(Brightness.dark, m3),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: getTheme(Brightness.light, m3),
      themeMode: themePrefs.mode,
      title: consts.appName,
      shortcuts: shortcuts,
    );
  }
}
