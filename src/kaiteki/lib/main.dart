import "dart:async";

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:kaiteki/account_manager.dart";
import "package:kaiteki/app.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/hive.dart" as hive;
import "package:kaiteki/l10n/localizations.dart";
import "package:kaiteki/theming/default/themes.dart";
import "package:kaiteki/ui/shared/crash_screen.dart";
import "package:kaiteki_core/http.dart";
import "package:kaiteki_core/utils.dart";
import "package:logging/logging.dart";
import "package:shared_preferences/shared_preferences.dart";

/// Main entrypoint.
Future<void> main() async {
  Logger.root.level = kDebugMode ? Level.FINEST : Level.INFO;

  if (kIsWeb) KaitekiClient.userAgent = null;

  final Widget app;

  try {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize shared preferences
    final sharedPrefs = await SharedPreferences.getInstance();

    // initialize hive
    hive.registerAdapters();
    if (!kIsWeb) {
      try {
        await hive.migrateBoxes();
      } catch (e, s) {
        Logger.root.shout("Failed to migrate hive boxes", e, s);
      }
    }
    await hive.initialize();

    // load repositories
    final accountRepository = await hive.getAccountRepository();
    final clientRepository = await hive.getClientRepository();

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
