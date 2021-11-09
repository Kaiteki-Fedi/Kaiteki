import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kaiteki/account_manager.dart';
import 'package:kaiteki/preferences/preference_container.dart';
import 'package:kaiteki/theming/app_themes/default_app_themes.dart';
import 'package:kaiteki/ui/screens.dart';
import 'package:provider/provider.dart';

class KaitekiApp extends StatelessWidget {
  const KaitekiApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext _) {
    return Builder(
      builder: (context) {
        // TODO: (code quality) listen to only a subset of preferences, to reduce unnecessary root rebuilds.
        final preferences = Provider.of<PreferenceContainer>(context);
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
            "/accounts": (_) => const ManageAccountsScreen(),
            "/about": (_) => AboutScreen(),
            "/settings": (_) => SettingsScreen(),
            "/settings/customization": (_) =>
                const CustomizationSettingsScreen(),
            "/settings/filtering": (_) => FilteringScreen(),
            "/settings/filtering/sensitivePosts": (_) =>
                const SensitivePostFilteringScreen(),
            "/settings/debug": (_) => const DebugScreen(),
            "/settings/debug/preferences": (_) =>
                const SharedPreferencesScreen(),
            '/login': (_) => const LoginScreen(),
            '/credits': (_) => const CreditsScreen(),
            '/discover-instances': (_) => const DiscoverInstancesScreen(),
          },
        );
      },
    );
  }

  Widget _buildMainRoute(_) {
    return Builder(builder: (context) {
      final accountManager = Provider.of<AccountManager>(context);

      if (accountManager.loggedIn) {
        return MainScreen();
      } else {
        return AccountRequiredScreen();
      }
    });
  }
}
