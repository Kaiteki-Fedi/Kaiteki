import "package:flutter/material.dart";
import "package:kaiteki/account_manager.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/model/auth/account.dart";
import "package:kaiteki/model/auth/account_key.dart";
import "package:kaiteki/model/auth/secret.dart";
import "package:kaiteki/theming/fallback.dart";
import "package:kaiteki_l10n/kaiteki_l10n.dart";
import "package:shared_preferences/shared_preferences.dart";

import "dummy_repository.dart";

class Bootstrapper {
  final ProviderContainer container;
  final String? locale;

  const Bootstrapper._(
    this.container,
    this.locale,
  );

  static Future<Bootstrapper> getInstance({
    String? locale,
    List<Account> initialAccounts = const [],
  }) async {
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

    final accountManager = container.read(accountManagerProvider.notifier);
    for (final account in initialAccounts) {
      await accountManager.add(account);
    }

    assert(
      initialAccounts.isEmpty ||
          container.read(accountManagerProvider).current != null,
    );

    return Bootstrapper._(container, locale);
  }

  Widget wrap(Widget child, {MediaQueryData? mediaQueryData}) {
    final locale = this.locale;

    Widget widget = MaterialApp(
      home: child,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: KaitekiLocalizations.localizationsDelegates,
      supportedLocales: KaitekiLocalizations.supportedLocales,
      locale: locale != null ? Locale(locale) : const Locale("en"),
      theme: fallbackTheme,
    );

    if (mediaQueryData != null) {
      widget = MediaQuery(
        data: mediaQueryData,
        child: widget,
      );
    }

    return ProviderScope(parent: container, child: widget);
  }
}
