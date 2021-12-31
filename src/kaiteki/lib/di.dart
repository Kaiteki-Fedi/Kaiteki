import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaiteki/account_manager.dart';
import 'package:kaiteki/preferences/preference_container.dart';
import 'package:kaiteki/theming/theme_container.dart';

export 'package:flutter_riverpod/flutter_riverpod.dart';

final preferenceProvider = ChangeNotifierProvider<PreferenceContainer>((_) {
  throw UnimplementedError();
});

final accountProvider = ChangeNotifierProvider<AccountManager>((_) {
  throw UnimplementedError();
});

final themeProvider = ChangeNotifierProvider<ThemeContainer>((_) {
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
