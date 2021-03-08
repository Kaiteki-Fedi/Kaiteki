import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kaiteki/account_container.dart';
import 'package:kaiteki/fediverse/api/definitions/definitions.dart';
import 'package:kaiteki/app_colors.dart';
import 'package:kaiteki/app_preferences.dart';
import 'package:kaiteki/repositories/account_secret_repository.dart';
import 'package:kaiteki/repositories/client_secret_repository.dart';
import 'package:kaiteki/theming/default_app_themes.dart';
import 'package:kaiteki/theming/material_app_theme.dart';
import 'package:kaiteki/theming/theme_container.dart';
import 'package:kaiteki/ui/screens/account_required_screen.dart';
import 'package:kaiteki/ui/screens/add_account_screen.dart';
import 'package:kaiteki/ui/screens/auth/login_screen.dart';
import 'package:kaiteki/ui/screens/main_screen.dart';
import 'package:kaiteki/ui/screens/manage_accounts_screen.dart';
import 'package:kaiteki/ui/screens/settings/about_screen.dart';
import 'package:kaiteki/ui/screens/settings/customization/customization_settings_screen.dart';
import 'package:kaiteki/ui/screens/settings/debug_screen.dart';
import 'package:kaiteki/ui/screens/settings/settings_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KaitekiApp extends StatefulWidget {
  const KaitekiApp({
    this.accountContainer,
    this.notifications,
    this.preferences,
  });

  @override
  _KaitekiAppState createState() => _KaitekiAppState();

  final SharedPreferences preferences;
  final AccountContainer accountContainer;
  final FlutterLocalNotificationsPlugin notifications;
}

class _KaitekiAppState extends State<KaitekiApp> {
  ThemeContainer _themeContainer;
  AppPreferences _preferences;

  @override
  void initState() {
    var defaultTheme = ThemeData.from(colorScheme: DefaultAppThemes.darkScheme);
    _themeContainer = ThemeContainer(MaterialAppTheme(defaultTheme));
    _preferences = AppPreferences();

    super.initState();
  }

  // TODO: (code quality) Move MultiProvider and Builder to "main.dart" instead of "app.dart".
  @override
  Widget build(BuildContext _) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _themeContainer),
        ChangeNotifierProvider.value(value: widget.accountContainer),
        ChangeNotifierProvider.value(value: _preferences),
      ],
      child: Builder(
        builder: (context) {
          // TODO: (code quality) listen to only a subset of preferences, to reduce unnecessary root rebuilds.
          var preferences = Provider.of<AppPreferences>(context);
          return MaterialApp(
            title: "Kaiteki",
            theme: ThemeData.from(
              colorScheme: DefaultAppThemes.lightScheme,
            ),
            darkTheme: ThemeData.from(
              colorScheme: DefaultAppThemes.darkScheme,
            ),
            color: AppColors.kaitekiDarkBackground.shade900,
            themeMode: preferences.theme,
            initialRoute: "/",
            routes: {
              "/": (_) => Builder(
                    builder: (context) {
                      if (Provider.of<AccountContainer>(context).loggedIn) {
                        return MainScreen();
                      } else {
                        return new AccountRequiredScreen();
                      }
                    },
                  ),
              "/accounts": (_) => ManageAccountsScreen(),
              "/accounts/add": (_) => AddAccountScreen(),
              "/debug": (_) => DebugScreen(),
              "/about": (_) => AboutScreen(),
              "/settings": (_) => SettingsScreen(),
              "/settings/customization": (_) => CustomizationSettingsScreen(),
            },
            onGenerateRoute: _generateRoute,
          );
        },
      ),
    );
  }

  Route<dynamic> _generateRoute(RouteSettings settings) {
    var loginPrefix = "/login/";

    if (settings.name.startsWith(loginPrefix)) {
      var id = settings.name.substring(loginPrefix.length);
      var definition = ApiDefinitions.definitions.firstWhere((o) => o.id == id);

      final screen = LoginScreen(
        image: AssetImage(definition.theme.iconAssetLocation),
        theme: _makeTheme(
          definition.theme.backgroundColor,
          definition.theme.primaryColor,
        ),
        onLogin: definition.createAdapter().login,
      );

      return MaterialPageRoute(builder: (_) => screen);
    }

    return null;
  }

  ThemeData _makeTheme(Color background, Color foreground) {
    return ThemeData.from(
      colorScheme: ColorScheme.dark(
        background: background,
        surface: background,
        primary: foreground,
        secondary: foreground,
        primaryVariant: foreground,
        secondaryVariant: foreground,
      ),
    ).copyWith(
      buttonTheme: ButtonThemeData(
        buttonColor: foreground,
      ),
    );
  }
}
