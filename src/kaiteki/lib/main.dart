import "dart:async";
import "dart:io";

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:hive/hive.dart";
import "package:kaiteki/account_manager.dart";
import "package:kaiteki/app.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/l10n/localizations.dart";
import "package:kaiteki/model/auth/account_key.dart";
import "package:kaiteki/model/auth/secret.dart";
import "package:kaiteki/repositories/hive_repository.dart";
import "package:kaiteki/theming/default/themes.dart";
import "package:kaiteki/ui/shared/crash_screen.dart";
import "package:kaiteki_core/utils.dart";
import "package:logging/logging.dart";
import "package:path/path.dart" as path;
import "package:path_provider/path_provider.dart";
import "package:shared_preferences/shared_preferences.dart";

/// Main entrypoint.
Future<void> main() async {
  Logger.root.level = kDebugMode ? Level.FINEST : Level.INFO;

  final Widget app;

  try {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize shared preferences
    final sharedPrefs = await SharedPreferences.getInstance();

    // initialize hive
    await initializeHive();
    await migrateHiveBoxes();

    // load repositories
    final accountRepository = await getAccountRepository();
    final clientRepository = await getClientRepository();

    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPrefs),
        accountSecretRepositoryProvider.overrideWithValue(accountRepository),
        clientSecretRepositoryProvider.overrideWithValue(clientRepository),
      ],
    );

    final accountManager = container.read(accountManagerProvider.notifier);
    await accountManager.restoreSessions();

    // construct app & run
    app = ProviderScope(
      parent: container,
      child: const KaitekiApp(),
    );
  } catch (e, s) {
    handleFatalError((e, s));
    return;
  }

  runApp(app);
}

AccountKey fromHive(dynamic k) => AccountKey.fromUri(k as String);

Future<HiveRepository<AccountSecret, AccountKey>> getAccountRepository() async {
  final accountBox = await Hive.openBox<AccountSecret>("account-secrets");
  return HiveRepository<AccountSecret, AccountKey>(
    accountBox,
    fromHive,
    toHive,
    true,
  );
}

Future<HiveRepository<ClientSecret, AccountKey>> getClientRepository() async {
  final clientBox = await Hive.openBox<ClientSecret>("client-secrets");
  return HiveRepository<ClientSecret, AccountKey>(
    clientBox,
    fromHive,
    toHive,
    true,
  );
}

void handleFatalError(TraceableError error) {
  final crashScreen = MaterialApp(
    theme: getDefaultTheme(Brightness.light, true),
    darkTheme: getDefaultTheme(Brightness.dark, true),
    localizationsDelegates: KaitekiLocalizations.localizationsDelegates,
    supportedLocales: KaitekiLocalizations.supportedLocales,
    home: CrashScreen(error),
  );
  runApp(crashScreen);
}

Future<void> initializeHive() async {
  final appSupportDir = await getApplicationSupportDirectory();

  Hive
    ..init(appSupportDir.path)
    ..registerAdapter(AccountKeyAdapter())
    ..registerAdapter(ClientSecretAdapter())
    ..registerAdapter(AccountSecretAdapter());
}

Future<bool> migrateHiveBoxes() async {
  const boxNames = [
    ("accountsecrets", "account-secrets"),
    ("clientsecrets", "client-secrets"),
  ];

  final documents = await getApplicationDocumentsDirectory();
  final appSupport = await getApplicationSupportDirectory();

  var boxMigrated = false;

  // tampering with FS is probably not possible here
  if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
    Future<void> migrateBox<T>(Box<T> from, Box<T> to) async {
      for (final key in from.keys) {
        await to.put(key, from.get(key) as T);
        await from.delete(key);
      }

      await to.close();

      assert(from.isEmpty);
      await from.close();
      await Hive.deleteBoxFromDisk(from.name);
    }

    for (final (from, to) in boxNames) {
      final boxExists = await Hive.boxExists(from, path: documents.path);
      if (!boxExists) continue;

      final fromBox = await Hive.openBox(from, path: documents.path);
      final toBox = await Hive.openBox(to, path: appSupport.path);
      await migrateBox(fromBox, toBox);

      boxMigrated = true;
    }

    return boxMigrated;
  }

  for (final (sourceName, destinationName) in boxNames) {
    for (final ext in [".hive", ".lock"]) {
      final sourcePath = path.join(documents.path, "$sourceName$ext");
      final destinationPath =
          path.join(appSupport.path, "$destinationName$ext");

      final file = File(sourcePath);

      if (await file.exists()) {
        await file.rename(destinationPath);
        boxMigrated = true;
      }
    }
  }

  return boxMigrated;
}

String toHive(AccountKey k) => k.toUri().toString();
