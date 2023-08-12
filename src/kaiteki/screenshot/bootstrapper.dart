import "package:flutter/material.dart";
import "package:kaiteki/account_manager.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/l10n/localizations.dart";
import "package:kaiteki/model/auth/account.dart";
import "package:kaiteki/model/auth/account_key.dart";
import "package:kaiteki/model/auth/secret.dart";
import "package:kaiteki/theming/default/themes.dart";
import "package:kaiteki_core/social.dart" hide ClientSecret;
import "package:shared_preferences/shared_preferences.dart";

import "dummy_repository.dart";
import "example_data.dart";
import "mastodon.dart";

class Bootstrapper {
  final ProviderContainer container;
  final String? locale;

  const Bootstrapper._(
    this.container,
    this.locale,
  );

  static Future<Bootstrapper> getInstance(String? locale) async {
    // ignore: invalid_use_of_visible_for_testing_member
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();

    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(preferences),
        accountSecretRepositoryProvider.overrideWithValue(
          DummyRepository<AccountSecret, AccountKey>(),
        ),
        clientSecretRepositoryProvider.overrideWithValue(
          DummyRepository<ClientSecret, AccountKey>(),
        ),
      ],
    );
    final adapter = TrendingMastodonAdapter("floss.social");
    final account = Account(
      accountSecret: null,
      clientSecret: null,
      adapter: adapter,
      key: const AccountKey(ApiType.mastodon, "floss.social", "Kaiteki"),
      user: alice,
    );
    await container.read(accountManagerProvider.notifier).add(account);

    return Bootstrapper._(container, locale);
  }

  Widget wrap(Widget child, Size size) {
    final locale = this.locale;
    return ProviderScope(
      parent: container,
      child: MediaQuery(
        data: MediaQueryData(devicePixelRatio: 2.0, size: size),
        child: MaterialApp(
          home: Builder(
            builder: (context) => ColoredBox(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: child,
            ),
          ),
          debugShowCheckedModeBanner: false,
          localizationsDelegates: KaitekiLocalizations.localizationsDelegates,
          supportedLocales: KaitekiLocalizations.supportedLocales,
          locale: locale != null ? Locale(locale) : const Locale("en"),
          theme: getDefaultTheme(Brightness.light, true),
        ),
      ),
    );
  }
}
