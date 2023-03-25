import "dart:collection";
import "dart:convert";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:kaiteki/account_manager.dart";
import "package:kaiteki/fediverse/adapter.dart";
import "package:kaiteki/fediverse/backends/mastodon/shared_adapter.dart";
import "package:kaiteki/fediverse/backends/misskey/adapter.dart";
import "package:kaiteki/model/auth/account.dart";
import "package:kaiteki/model/language.dart";
import "package:kaiteki/text/parsers/html_text_parser.dart";
import "package:kaiteki/text/parsers/md_text_parser.dart";
import "package:kaiteki/text/parsers/mfm_text_parser.dart";
import "package:kaiteki/text/parsers/social_text_parser.dart";
import "package:kaiteki/text/parsers/text_parser.dart";
import "package:kaiteki/translation/language_identificator.dart";
import "package:kaiteki/translation/translator.dart";
import "package:shared_preferences/shared_preferences.dart";

export "package:flutter_riverpod/flutter_riverpod.dart";

final accountManagerProvider = ChangeNotifierProvider<AccountManager>((_) {
  throw UnimplementedError();
});

final sharedPreferencesProvider = Provider<SharedPreferences>((_) {
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

final translatorProvider = Provider<Translator?>((_) {
  return null;
});
final languageIdentificatorProvider = Provider<LanguageIdentificator?>((_) {
  return null;
});

final textParserProvider = Provider<Set<TextParser>>(
  (ref) {
    const socialTextParser = SocialTextParser();
    final adapter = ref.watch(adapterProvider);
    if (adapter is MisskeyAdapter) {
      return const {MarkdownTextParser(), MfmTextParser(), socialTextParser};
    } else if (adapter is SharedMastodonAdapter) {
      return const {MastodonHtmlTextParser(), socialTextParser};
    } else {
      return const {socialTextParser};
    }
  },
  dependencies: [adapterProvider],
);

final languageListProvider =
    FutureProvider<UnmodifiableListView<Language>>((ref) async {
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
