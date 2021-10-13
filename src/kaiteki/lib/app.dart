import 'package:flutter/material.dart';
import 'package:kaiteki/account_manager.dart';
import 'package:kaiteki/app_colors.dart';
import 'package:kaiteki/preferences/preference_container.dart';
import 'package:kaiteki/theming/app_themes/default_app_themes.dart';
import 'package:kaiteki/ui/screens/account_required_screen.dart';
import 'package:kaiteki/ui/screens/add_account_screen.dart';
import 'package:kaiteki/ui/screens/auth/login_screen.dart';
import 'package:kaiteki/ui/screens/main_screen.dart';
import 'package:kaiteki/ui/screens/manage_accounts_screen.dart';
import 'package:kaiteki/ui/screens/settings/about_screen.dart';
import 'package:kaiteki/ui/screens/settings/credits_screen.dart';
import 'package:kaiteki/ui/screens/settings/customization/customization_settings_screen.dart';
import 'package:kaiteki/ui/screens/settings/debug/shared_preferences_screen.dart';
import 'package:kaiteki/ui/screens/settings/debug_screen.dart';
import 'package:kaiteki/ui/screens/settings/filtering/filtering_screen.dart';
import 'package:kaiteki/ui/screens/settings/filtering/sensitive_post_filtering_screen.dart';
import 'package:kaiteki/ui/screens/settings/settings_screen.dart';
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
          theme: ThemeData.from(
            colorScheme: DefaultAppThemes.lightScheme,
          ),
          darkTheme: ThemeData.from(
            colorScheme: DefaultAppThemes.darkScheme,
          ),
          color: AppColors.kaitekiDarkBackground.shade900,
          themeMode: preferences.get().theme,
          initialRoute: "/",
          routes: {
            "/": (_) => Builder(builder: (context) {
                  if (Provider.of<AccountManager>(context).loggedIn) {
                    return MainScreen();
                  } else {
                    return AccountRequiredScreen();
                  }
                }),
            "/accounts": (_) => const ManageAccountsScreen(),
            "/accounts/add": (_) => const AddAccountScreen(),
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
            '/credits': (_) => const CreditsScreen(),
          },
        );
      },
    );
  }
}
