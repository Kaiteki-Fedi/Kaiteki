import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/theming/app_themes/default_app_themes.dart';
import 'package:kaiteki/ui/screens.dart';

class KaitekiApp extends ConsumerWidget {
  const KaitekiApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: (code quality) listen to only a subset of preferences, to reduce unnecessary root rebuilds.
    final preferences = ref.watch(preferenceProvider);
    return MaterialApp(
      title: "Kaiteki",
      theme: ThemeData.from(colorScheme: DefaultAppThemes.lightScheme),
      darkTheme: ThemeData.from(colorScheme: DefaultAppThemes.darkScheme),
      themeMode: preferences.get().theme,
      initialRoute: "/",
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routes: {
        "/": _buildMainRoute,
        "/about": (_) => const AboutScreen(),
        "/settings": (_) => const SettingsScreen(),
        "/settings/customization": (_) => const CustomizationSettingsScreen(),
        "/settings/filtering": (_) => const FilteringScreen(),
        "/settings/filtering/sensitivePosts": (_) {
          return const SensitivePostFilteringScreen();
        },
        "/settings/debug": (_) => const DebugScreen(),
        "/settings/debug/preferences": (_) => const SharedPreferencesScreen(),
        '/login': (_) => const LoginScreen(),
        '/credits': (_) => const CreditsScreen(),
        '/discover-instances': (_) => const DiscoverInstancesScreen(),
      },
    );
  }

  Widget _buildMainRoute(context) {
    return Consumer(builder: (context, ref, child) {
      return ref.watch(accountProvider).loggedIn
          ? const MainScreen()
          : const AccountRequiredScreen();
    });
  }
}
