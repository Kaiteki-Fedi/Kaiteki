import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaiteki/account_manager.dart';
import 'package:kaiteki/fediverse/adapter.dart';
import 'package:kaiteki/model/auth/account.dart';
import 'package:kaiteki/preferences/app_preferences.dart';
import 'package:kaiteki/preferences/theme_preferences.dart';
import 'package:kaiteki/translation/language_identificator.dart';
import 'package:kaiteki/translation/translator.dart';

export 'package:flutter_riverpod/flutter_riverpod.dart';

final accountManagerProvider = ChangeNotifierProvider<AccountManager>((_) {
  throw UnimplementedError();
});

final accountProvider = Provider<Account?>(
  (ref) {
    final accountManager = ref.watch(accountManagerProvider);
    // ignore: deprecated_member_use_from_same_package
    return accountManager.current;
  },
  dependencies: [accountManagerProvider],
);

final adapterProvider = Provider<BackendAdapter>(
  (ref) => ref.watch(accountProvider)!.adapter,
  dependencies: [accountProvider],
);

final themeProvider = ChangeNotifierProvider<ThemePreferences>((_) {
  throw UnimplementedError();
});

final preferencesProvider = ChangeNotifierProvider<AppPreferences>((_) {
  throw UnimplementedError();
});

final translatorProvider = Provider<Translator?>((_) {
  return null;
});
final languageIdentificatorProvider = Provider<LanguageIdentificator?>((_) {
  return null;
});

extension BuildContextExtensions on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  MaterialLocalizations get materialL10n {
    return Localizations.of<MaterialLocalizations>(
      this,
      MaterialLocalizations,
    )!;
  }
}
