import 'package:flutter/material.dart';
import 'package:kaiteki/account_container.dart';
import 'package:kaiteki/app_preferences.dart';
import 'package:kaiteki/theming/theme_container.dart';
import 'package:kaiteki/ui/screens/main_screen.dart';
import 'package:kaiteki/ui/screens/settings/about_screen.dart';
import 'package:kaiteki/ui/screens/settings/debug_screen.dart';
import 'package:provider/provider.dart';

class KaitekiApp extends StatefulWidget {
  @override
  _KaitekiAppState createState() => _KaitekiAppState();
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
      accentColor: Colors.pinkAccent.shade100
    );
    _themeContainer = ThemeContainer(defaultTheme);

    _accountContainer = AccountContainer();
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
        ChangeNotifierProvider.value(value: _preferences)
      ],
      child: Builder(
        builder: (context) {
          var appBackground = _themeContainer.getBackground();
          var themeContainer = Provider.of<ThemeContainer>(context);

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
                color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.75),
                child: MaterialApp(
                  title: 'Kaiteki',
                  theme: themeContainer.getCurrentTheme(),
                  home: MainScreen(),
                  routes: {
                    "/debug": (_) => DebugScreen(),
                    "/about": (_) => AboutScreen(),
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

