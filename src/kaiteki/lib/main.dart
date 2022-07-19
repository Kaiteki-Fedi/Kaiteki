import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaiteki/account_manager.dart';
import 'package:kaiteki/app.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/logger.dart';
import 'package:kaiteki/preferences/app_preferences.dart';
import 'package:kaiteki/preferences/preference_container.dart';
import 'package:kaiteki/preferences/theme_preferences.dart';
import 'package:kaiteki/repositories/account_secret_repository.dart';
import 'package:kaiteki/repositories/client_secret_repository.dart';
import 'package:kaiteki/repositories/secret_storages/shared_preferences_secret_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

final logger = getLogger('Kaiteki');

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

  final sharedPrefs = await SharedPreferences.getInstance();
  final themePreferences = ThemePreferences(
    sharedPrefs,
    await _useMaterial3ByDefault,
  );

  final accountManager = await getAccountManager(sharedPrefs);
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

/// Initializes the account manager.
Future<AccountManager> getAccountManager(SharedPreferences sharedPrefs) async {
  final accountStorage = SharedPreferencesAccountSecretStorage(sharedPrefs);
  final accounts = AccountSecretRepository(accountStorage);

  final clientStorage = SharedPreferencesClientSecretStorage(sharedPrefs);
  final clients = ClientSecretRepository(clientStorage);

  try {
    await accounts.initialize();
    await clients.initialize();
  } catch (e) {
    logger.e("Failed to initialize account and client secret repositories", e);
    rethrow;
  }

  final manager = AccountManager(accounts, clients);
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
