import "dart:async";
import "dart:io";

import "package:device_info_plus/device_info_plus.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:hive_flutter/hive_flutter.dart";
import "package:kaiteki/account_manager.dart";
import "package:kaiteki/app.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/model/auth/account_key.dart";
import "package:kaiteki/model/auth/secret.dart";
import "package:kaiteki/preferences/app_preferences.dart";
import "package:kaiteki/preferences/theme_preferences.dart";
import "package:kaiteki/repositories/hive_repository.dart";
import "package:kaiteki/theming/default/themes.dart";
import "package:kaiteki/ui/shared/crash_screen.dart";
import "package:shared_preferences/shared_preferences.dart";

Future<bool> get _useMaterial3ByDefault async {
  if (kIsWeb || !Platform.isAndroid) return true;
  final androidInfo = await DeviceInfoPlugin().androidInfo;
  return androidInfo.version.sdkInt >= 12;
}

/// Main entrypoint.
Future<void> main() async {
  final Widget app;

  try {
    // we need to run this to be able to get access to SharedPreferences
    WidgetsFlutterBinding.ensureInitialized();

    await initializeHive();
    final accountManager = await getAccountManager();

    final sharedPrefs = await SharedPreferences.getInstance();
    final themePreferences = ThemePreferences(
      sharedPrefs,
      await _useMaterial3ByDefault,
    );

    final appPreferences = AppPreferences();
    await appPreferences.initialize(sharedPrefs);

    // construct app & run
    app = ProviderScope(
      overrides: [
        themeProvider.overrideWith((_) => themePreferences),
        preferencesProvider.overrideWith((_) => appPreferences),
        accountManagerProvider.overrideWith((_) => accountManager),
      ],
      child: const KaitekiApp(),
    );
  } catch (e, s) {
    handleFatalError(e, s);
    return;
  }

  runApp(app);
}

void handleFatalError(Object error, StackTrace stackTrace) {
  final crashScreen = MaterialApp(
    theme: getDefaultTheme(Brightness.light, true),
    darkTheme: getDefaultTheme(Brightness.dark, true),
    home: CrashScreen(
      exception: error,
      stackTrace: stackTrace,
    ),
  );
  runApp(crashScreen);
}

Future<void> initializeHive() async {
  await Hive.initFlutter();
  Hive
    ..registerAdapter(AccountKeyAdapter())
    ..registerAdapter(ClientSecretAdapter())
    ..registerAdapter(AccountSecretAdapter());
}

/// Initializes the account manager.
Future<AccountManager> getAccountManager() async {
  AccountKey fromHive(dynamic k) => AccountKey.fromUri(k as String);
  String toHive(AccountKey k) => k.toUri().toString();

  final accountBox = await Hive.openBox<AccountSecret>("accountSecrets");
  final accountRepository = HiveRepository<AccountSecret, AccountKey>(
    accountBox,
    fromHive,
    toHive,
  );

  final clientBox = await Hive.openBox<ClientSecret>("clientSecrets");
  final clientRepository = HiveRepository<ClientSecret, AccountKey>(
    clientBox,
    fromHive,
    toHive,
  );

  final manager = AccountManager(accountRepository, clientRepository);
  await manager.loadAllAccounts();
  return manager;
}
