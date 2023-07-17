import "dart:collection";
import "dart:convert";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:kaiteki/account_manager.dart";
import "package:kaiteki/l10n/localizations.dart";
import "package:kaiteki/model/auth/account.dart";
import "package:kaiteki/model/language.dart";
import "package:kaiteki/text/parsers/html_text_parser.dart";
import "package:kaiteki/text/parsers/md_text_parser.dart";
import "package:kaiteki/text/parsers/mfm_text_parser.dart";
import "package:kaiteki/text/parsers/social_text_parser.dart";
import "package:kaiteki/text/parsers/text_parser.dart";
import "package:kaiteki/translation/language_identificator.dart";
import "package:kaiteki/translation/translator.dart";
import "package:kaiteki_core/backends/mastodon.dart";
import "package:kaiteki_core/backends/misskey.dart";
import "package:kaiteki_core/kaiteki_core.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:shared_preferences/shared_preferences.dart";

export "package:flutter_riverpod/flutter_riverpod.dart";

part "di.g.dart";

final sharedPreferencesProvider = Provider<SharedPreferences>((_) {
  throw UnimplementedError();
});

@Riverpod(keepAlive: true, dependencies: [AccountManager])
Account? account(AccountRef ref) => ref.watch(accountManagerProvider).current;

@Riverpod(keepAlive: true, dependencies: [account])
BackendAdapter adapter(AdapterRef ref) => ref.watch(accountProvider)!.adapter;

@Riverpod()
Translator? translator(TranslatorRef _) => null;

@Riverpod()
LanguageIdentificator? languageIdentificator(LanguageIdentificatorRef _) {
  return null;
}

@Riverpod(keepAlive: true, dependencies: [adapter])
Set<TextParser> textParser(TextParserRef ref) {
  const socialTextParser = SocialTextParser();
  return switch (ref.watch(adapterProvider)) {
    MisskeyAdapter() => const {
        MarkdownTextParser(),
        MfmTextParser(),
        socialTextParser
      },
    SharedMastodonAdapter() => const {
        MastodonHtmlTextParser(),
        socialTextParser
      },
    _ => const {socialTextParser}
  };
}

@Riverpod(keepAlive: true)
Future<UnmodifiableListView<Language>> languageList(LanguageListRef ref) async {
  final languagesJson =
      await rootBundle.loadString("assets/languages.json", cache: false);

  final json = jsonDecode(languagesJson) as List<dynamic>;
  final languages =
      json.cast<List<dynamic>>().map((e) => Language(e[0], e[1])).toList()
        ..sort((a, b) {
          final aName = a.englishName;
          final bName = b.englishName;
          if (aName == null || bName == null) return 0;
          return aName.compareTo(bName);
        });

  return UnmodifiableListView(languages);
}

extension BuildContextExtensions on BuildContext {
  KaitekiLocalizations get l10n => KaitekiLocalizations.of(this)!;

  MaterialLocalizations get materialL10n {
    return Localizations.of<MaterialLocalizations>(
      this,
      MaterialLocalizations,
    )!;
  }
}
