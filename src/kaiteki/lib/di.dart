import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaiteki/account_manager.dart';
import 'package:kaiteki/fediverse/adapter.dart';
import 'package:kaiteki/preferences/theme_preferences.dart';

export 'package:flutter_riverpod/flutter_riverpod.dart';

final accountProvider = ChangeNotifierProvider<AccountManager>((_) {
  throw UnimplementedError();
});

final adapterProvider = Provider<FediverseAdapter>((_) {
  throw UnimplementedError();
});

final themeProvider = ChangeNotifierProvider<ThemePreferences>((_) {
  throw UnimplementedError();
});

extension BuildContextExtensions on BuildContext {
  AppLocalizations getL10n() => AppLocalizations.of(this)!;

  MaterialLocalizations getMaterialL10n() {
    return Localizations.of<MaterialLocalizations>(
      this,
      MaterialLocalizations,
    )!;
  }
}
