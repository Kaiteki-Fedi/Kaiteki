import "dart:async";

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:kaiteki/account_manager.dart";
import "package:kaiteki/app.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/hive.dart" as hive;
import "package:kaiteki/l10n/localizations.dart";
import "package:kaiteki/model/auth/account_key.dart";
import "package:kaiteki/model/startup_state.dart";
import "package:kaiteki/preferences/app_preferences.dart";
import "package:kaiteki/theming/default/themes.dart";
import "package:kaiteki/ui/shared/crash_screen.dart";
import "package:kaiteki/ui/splash_screen.dart";
import "package:kaiteki_core/http.dart";
import "package:kaiteki_core/utils.dart";
import "package:logging/logging.dart";
import "package:shared_preferences/shared_preferences.dart";

late final ProviderSubscription? _accountManagerSubscription;
late final ProviderContainer _container;

/// Main entrypoint.
Future<void> main() async {
  Logger.root.level = kDebugMode ? Level.FINEST : Level.INFO;
  if (kIsWeb) KaitekiClient.userAgent = null;

  try {
    // initialize
    WidgetsFlutterBinding.ensureInitialized();
    final sharedPreferences = await SharedPreferences.getInstance();
    final startup = _startup(sharedPreferences).asBroadcastStream();

    // show splash screen with startup state
    runApp(
      MaterialApp(
        home: SplashScreen(stream: startup),
        theme: makeDefaultTheme(Brightness.light, true),
        darkTheme: makeDefaultTheme(Brightness.dark, true),
      ),
    );

    // wait for startup to finish
    await startup.last;

    // construct app & run
    runApp(
      ProviderScope(
        parent: _container,
        child: const KaitekiApp(),
      ),
    );
  } catch (e, s) {
    handleFatalError((e, s));
  }
}

Stream<StartupState> _startup(SharedPreferences sharedPreferences) async* {
  // initialize hive
  yield const StartupLoadingDatabase();
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
  yield const StartupLoadingAccounts();
  final accountRepository = await hive.getAccountRepository();
  final clientRepository = await hive.getClientRepository();

  _container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      accountSecretRepositoryProvider.overrideWithValue(accountRepository),
      clientSecretRepositoryProvider.overrideWithValue(clientRepository),
    ],
  );

  AccountKey? lastAccount;
  final priorityAccount = _container.read(lastUsedAccount).value;
  final accountManager = _container.read(accountManagerProvider.notifier);

  final sessions = accountManager
      .restoreSessions(priorityAccount: priorityAccount)
      .asBroadcastStream();

  await for (final account in sessions) {
    yield StartupSignIn(account);

    if (priorityAccount == null || lastAccount == priorityAccount) break;

    lastAccount = account;
  }

  sessions.last; // force sessions to continue restoring

  _accountManagerSubscription = _container.listen(
    accountManagerProvider,
    (_, next) => _container.read(lastUsedAccount).value = next.current?.key,
  );
}

void handleFatalError(TraceableError error) {
  final crashScreen = MaterialApp(
    theme: makeDefaultTheme(Brightness.light, true),
    darkTheme: makeDefaultTheme(Brightness.dark, true),
    localizationsDelegates: KaitekiLocalizations.localizationsDelegates,
    supportedLocales: KaitekiLocalizations.supportedLocales,
    home: CrashScreen(error),
  );
  runApp(crashScreen);
}
