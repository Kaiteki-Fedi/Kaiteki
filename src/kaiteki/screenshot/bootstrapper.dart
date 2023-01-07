import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kaiteki/account_manager.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/adapter.dart';
import 'package:kaiteki/fediverse/api_type.dart';
import 'package:kaiteki/model/auth/account.dart';
import 'package:kaiteki/model/auth/account_key.dart';
import 'package:kaiteki/model/auth/secret.dart';
import 'package:kaiteki/preferences/app_preferences.dart';
import 'package:kaiteki/theming/default/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dummy_repository.dart';
import 'example_data.dart';
import 'mastodon.dart';

class Bootstrapper {
  final BackendAdapter adapter;
  final AccountManager accountManager;
  final AppPreferences preferences;
  final String? locale;

  const Bootstrapper._(
    this.adapter,
    this.accountManager,
    this.preferences,
    this.locale,
  );

  static Future<Bootstrapper> getInstance(String? locale) async {
    final accountRepo = DummyRepository<AccountSecret, AccountKey>();
    final clientRepo = DummyRepository<ClientSecret, AccountKey>();
    final accountManager = AccountManager(accountRepo, clientRepo);
    final adapter = TrendingMastodonAdapter("floss.social");
    final account = Account(
      accountSecret: null,
      clientSecret: null,
      adapter: adapter,
      key: const AccountKey(ApiType.mastodon, "floss.social", "Kaiteki"),
      user: alice,
    );
    await accountManager.add(account);

    // ignore: invalid_use_of_visible_for_testing_member
    SharedPreferences.setMockInitialValues({});
    final sharedPreferences = await SharedPreferences.getInstance();

    final preferences = AppPreferences(sharedPreferences);

    return Bootstrapper._(adapter, accountManager, preferences, locale);
  }

  Widget wrap(Widget child) {
    return ProviderScope(
      overrides: [
        accountManagerProvider.overrideWith((_) => accountManager),
        adapterProvider.overrideWith((_) => adapter),
        preferencesProvider.overrideWith((ref) => preferences),
      ],
      child: MediaQuery(
        data: const MediaQueryData(devicePixelRatio: 2.0),
        child: MaterialApp(
          home: Builder(
            builder: (context) => ColoredBox(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: child,
            ),
          ),
          debugShowCheckedModeBanner: false,
          useInheritedMediaQuery: true,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: locale != null ? Locale(locale!) : const Locale("en"),
          theme: getDefaultTheme(Brightness.light, true),
        ),
      ),
    );
  }
}
