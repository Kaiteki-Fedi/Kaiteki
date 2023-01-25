import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/app_preferences.dart" as preferences;
import "package:kaiteki/theming/kaiteki/text_theme.dart";

class LocaleListTile extends ConsumerWidget {
  const LocaleListTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    // final prefs = ref.watch(preferencesProvider);
    return ListTile(
      leading: const Icon(Icons.public),
      title: Text(l10n.settingsLocale),
      subtitle: Text(Localizations.localeOf(context).toLanguageTag()),
      onTap: () => _onTap(context, ref),
    );
  }

  Future<void> _onTap(BuildContext context, WidgetRef ref) async {
    final locale = await showDialog<LocaleChoice?>(
      context: context,
      builder: (_) => const SelectLocaleDialog(),
    );

    if (locale == null) return;

    ref.read(preferences.locale).value = locale.languageCode;
  }
}

class SelectLocaleDialog extends StatelessWidget {
  const SelectLocaleDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SimpleDialog(
      title: Text(l10n.selectLocaleTitle),
      children: [
        SimpleDialogOption(
          child: Text(l10n.localeSystem),
          onPressed: () => Navigator.of(context).maybePop(
            const LocaleChoice.systemDefault(),
          ),
        ),
        const Divider(),
        for (var locale in AppLocalizations.supportedLocales)
          SimpleDialogOption(
            child: Text(
              locale.toString(),
              style: Theme.of(context).ktkTextTheme?.monospaceTextStyle,
            ),
            onPressed: () => Navigator.of(context).maybePop(
              LocaleChoice(locale.toLanguageTag()),
            ),
          ),
      ],
    );
  }
}

class LocaleChoice {
  final String? languageCode;
  const LocaleChoice(String this.languageCode);
  const LocaleChoice.systemDefault() : languageCode = null;
}
