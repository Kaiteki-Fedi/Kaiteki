import "dart:convert";

import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:kaiteki/account_manager.dart";
import "package:kaiteki/model/auth/account.dart";
import "package:kaiteki/model/auth/account_key.dart";
import "package:kaiteki/model/language.dart";
import "package:kaiteki/text/parsers/html_text_parser.dart";
import "package:kaiteki/text/parsers/md_text_parser.dart";
import "package:kaiteki/text/parsers/mfm_text_parser.dart";
import "package:kaiteki/text/parsers/social_text_parser.dart";
import "package:kaiteki/text/parsers/text_parser.dart";
import "package:kaiteki/translation/language_identificator.dart";
import "package:kaiteki/translation/translator.dart";
import "package:kaiteki_core/kaiteki_core.dart";
import "package:kaiteki_core_backends/mastodon.dart";
import "package:kaiteki_core_backends/misskey.dart";
import "package:kaiteki_l10n/kaiteki_l10n.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:shared_preferences/shared_preferences.dart";

export "package:flutter_riverpod/flutter_riverpod.dart";

part "di.g.dart";

final sharedPreferencesProvider = Provider<SharedPreferences>((_) {
  throw UnimplementedError();
});

@Riverpod(keepAlive: true, dependencies: [AccountManager])
Account? account(AccountRef ref, AccountKey key) {
  return ref.watch(
    accountManagerProvider.select(
      (e) => e.accounts.firstWhereOrNull((e) => e.key == key),
    ),
  );
}

@Riverpod(keepAlive: true, dependencies: [AccountManager])
Account? currentAccount(CurrentAccountRef ref) =>
    ref.watch(accountManagerProvider).current;

@Riverpod(keepAlive: true, dependencies: [currentAccount])
BackendAdapter adapter(AdapterRef ref) =>
    ref.watch(currentAccountProvider.select((e) => e!.adapter));

@Riverpod()
Translator? translator(TranslatorRef _) => null;

@Riverpod()
LanguageIdentificator? languageIdentificator(LanguageIdentificatorRef _) {
  return null;
}

@Riverpod(keepAlive: true, dependencies: [adapter])
Set<TextParser> textParser(TextParserRef ref) {
  const socialTextParser = SocialTextParser();

  BackendAdapter? adapter;

  try {
    adapter = ref.watch(adapterProvider);
  } catch (_) {
    // HACK(Craftplacer)
  }

  return switch (adapter) {
    MisskeyAdapter() => const {
        MfmTextParser(),
        MarkdownTextParser(),
        socialTextParser,
      },
    SharedMastodonAdapter() => const {
        MastodonHtmlTextParser(),
        socialTextParser,
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
