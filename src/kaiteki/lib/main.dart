import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kaiteki/account_manager.dart';
import 'package:kaiteki/app.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/model/account_key.dart';
import 'package:kaiteki/model/auth/account_secret.dart';
import 'package:kaiteki/model/auth/client_secret.dart';
import 'package:kaiteki/preferences/app_preferences.dart';
import 'package:kaiteki/preferences/preference_container.dart';
import 'package:kaiteki/preferences/theme_preferences.dart';
import 'package:kaiteki/repositories/hive_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> get _useMaterial3ByDefault async {
  if (!Platform.isAndroid) return false;
  final androidInfo = await DeviceInfoPlugin().androidInfo;
  return (androidInfo.version.sdkInt ?? 0) >= 12;
}

/// Main entrypoint.
Future<void> main() async {
  GoRouter.setUrlPathStrategy(UrlPathStrategy.hash);

  // we need to run this to be able to get access to SharedPreferences
  WidgetsFlutterBinding.ensureInitialized();

  await initializeHive();
  final accountManager = await getAccountManager();

  final sharedPrefs = await SharedPreferences.getInstance();
  final themePreferences = ThemePreferences(
    sharedPrefs,
    await _useMaterial3ByDefault,
  );
  final appPreferences = getPreferences(sharedPrefs);

  // construct app & run
  final app = ProviderScope(
    overrides: [
      themeProvider.overrideWithValue(themePreferences),
      preferenceProvider.overrideWithValue(appPreferences),
      accountProvider.overrideWithValue(accountManager),
    ],
    child: KaitekiApp(),
  );

  runApp(app);
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
  AccountKey fromHive(dynamic k) => AccountKey.fromUri(k);
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

/// Initializes app preferences.
PreferenceContainer getPreferences(SharedPreferences sharedPrefs) {
  late final AppPreferences appPreferences;

  if (sharedPrefs.containsKey('preferences')) {
    final json = jsonDecode(sharedPrefs.getString('preferences')!);
    appPreferences = AppPreferences.fromJson(json);
  } else {
    appPreferences = AppPreferences();
  }

  return PreferenceContainer(appPreferences);
}
