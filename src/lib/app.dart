import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kaiteki/account_container.dart';
import 'package:kaiteki/app_preferences.dart';
import 'package:kaiteki/repositories/account_secret_repository.dart';
import 'package:kaiteki/repositories/client_secret_repository.dart';
import 'package:kaiteki/theming/material_app_theme.dart';
import 'package:kaiteki/theming/theme_container.dart';
import 'package:kaiteki/ui/screens/add_account_screen.dart';
import 'package:kaiteki/ui/screens/main_screen.dart';
import 'package:kaiteki/ui/screens/manage_accounts_screen.dart';
import 'package:kaiteki/ui/screens/settings/about_screen.dart';
import 'package:kaiteki/ui/screens/settings/customization/customization_settings_screen.dart';
import 'package:kaiteki/ui/screens/settings/debug_screen.dart';
import 'package:kaiteki/ui/screens/settings_screen.dart';
import 'package:provider/provider.dart';

class KaitekiApp extends StatefulWidget {
  const KaitekiApp(
    this.accountSecrets,
    this.clientSecrets,
    this.notifications,
  );

  @override
  _KaitekiAppState createState() => _KaitekiAppState();

  final AccountSecretRepository accountSecrets;
  final ClientSecretRepository clientSecrets;
  final FlutterLocalNotificationsPlugin notifications;
}

class _KaitekiAppState extends State<KaitekiApp> {
  ThemeContainer _themeContainer;
  AccountContainer _accountContainer;
  AppPreferences _preferences;

  @override
  void initState() {
    var defaultTheme = ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      primarySwatch: Colors.blue,
      brightness: Brightness.dark,
      accentColor: Colors.pinkAccent.shade100,
      fontFamily: "Noto Sans CJK"
    );
    _themeContainer = ThemeContainer(MaterialAppTheme(defaultTheme));

    _accountContainer = AccountContainer(widget.accountSecrets, widget.clientSecrets);
    _accountContainer.loadAllAccounts();

    _preferences = AppPreferences();

    super.initState();
  }

  @override
  Widget build(BuildContext _) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _themeContainer),
        ChangeNotifierProvider.value(value: _accountContainer),
        ChangeNotifierProvider.value(value: _preferences),
        ChangeNotifierProvider.value(value: widget.accountSecrets),
        ChangeNotifierProvider.value(value: widget.clientSecrets),
        Provider.value(value: widget.notifications),
      ],
      child: Builder(
        builder: (context) {
          var appPreferences = _preferences.getPreferredAppName();

          var themeContainer = Provider.of<ThemeContainer>(context);
          var appBackground = themeContainer.background;
          var materialTheme = themeContainer.materialTheme;
          var backgroundColor = materialTheme.canvasColor;

          backgroundColor = backgroundColor.withOpacity(themeContainer.backgroundOpacity);

          // if (!themeContainer.hasBackground)
          //   assert(themeContainer.backgroundOpacity != 1);

          return Stack(
            alignment: Alignment.topLeft,
            fit: StackFit.expand,
            children: [
              if (themeContainer.hasBackground)
                Image(
                  image: appBackground,
                  fit: BoxFit.cover,
                ),
              Container(
                color: backgroundColor,
                child: MaterialApp(
                  title: appPreferences,
                  theme: materialTheme,
                  home: MainScreen(),
                  routes: {
                    "/accounts": (_) => ManageAccountsScreen(),
                    "/accounts/add": (_) => AddAccountScreen(),
                    "/debug": (_) => DebugScreen(),
                    "/about": (_) => AboutScreen(),
                    "/settings": (_) => SettingsScreen(),
                    "/settings/customization": (_) => CustomizationSettingsScreen(),
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

