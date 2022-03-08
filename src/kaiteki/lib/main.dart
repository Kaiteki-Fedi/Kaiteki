import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:kaiteki/account_manager.dart';
import 'package:kaiteki/app.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/logger.dart';
import 'package:kaiteki/preferences/app_preferences.dart';
import 'package:kaiteki/preferences/preference_container.dart';
import 'package:kaiteki/repositories/account_secret_repository.dart';
import 'package:kaiteki/repositories/client_secret_repository.dart';
import 'package:kaiteki/repositories/secret_storages/shared_preferences_secret_storage.dart';
import 'package:kaiteki/theming/app_themes/default_app_themes.dart';
import 'package:kaiteki/theming/theme_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

final logger = getLogger('Kaiteki');

/// Main entrypoint.
Future<void> main() async {
  GoRouter.setUrlPathStrategy(UrlPathStrategy.path);

  // we need to run this to be able to get access to SharedPreferences
  WidgetsFlutterBinding.ensureInitialized();

  final themeContainer = ThemeContainer(lightAppTheme);
  final sharedPrefs = await SharedPreferences.getInstance();
  final accountManager = await getAccountManager(sharedPrefs);
  final appPreferences = getPreferences(sharedPrefs);

  // construct app & run
  final app = ProviderScope(
    child: KaitekiApp(),
    overrides: [
      themeProvider.overrideWithValue(themeContainer),
      preferenceProvider.overrideWithValue(appPreferences),
      accountProvider.overrideWithValue(accountManager),
    ],
  );

  runApp(app);
}

/// Initializes the account manager.
Future<AccountManager> getAccountManager(SharedPreferences sharedPrefs) async {
  final secrets = SharedPreferencesSecureStorage(sharedPrefs);
  final accounts = AccountSecretRepository(secrets);
  final clients = ClientSecretRepository(secrets);

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

/// Initializes flutter_local_notifications.
Future<FlutterLocalNotificationsPlugin?> initializeNotifications() async {
  if (kIsWeb) return null;

  final plugin = FlutterLocalNotificationsPlugin();
  const initSettings = InitializationSettings(
    android: AndroidInitializationSettings("@mipmap/ic_kaiteki"),
  );

  await plugin.initialize(initSettings);

  return plugin;
}
