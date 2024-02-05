import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki_l10n/kaiteki_l10n.dart";
import "package:kaiteki/preferences/app_preferences.dart" as preferences;
import "package:kaiteki/theming/text_theme.dart";
import "package:kaiteki/ui/shared/common.dart";

class LocaleListTile extends ConsumerWidget {
  const LocaleListTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    // final prefs = ref.watch(preferencesProvider);
    final locale = Localizations.localeOf(context);
    final localeName = getLocaleName(locale);
    return ListTile(
      leading: const Icon(Icons.public),
      title: Text(l10n.settingsLocale),
      subtitle: Text(localeName ?? locale.toString()),
      onTap: () => _onTap(context, ref),
    );
  }

  Future<void> _onTap(BuildContext context, WidgetRef ref) async {
    final locale = await showDialog<SelectLocaleDialogResult?>(
      context: context,
      builder: (_) => SelectLocaleDialog(
        selectedLocale: ref.read(preferences.locale).value,
      ),
    );

    if (locale == null) return;

    ref.read(preferences.locale).value = locale.$1;
  }
}

typedef SelectLocaleDialogResult = (Locale?,);

class SelectLocaleDialog extends StatelessWidget {
  final Locale? selectedLocale;

  const SelectLocaleDialog({
    required this.selectedLocale,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AlertDialog(
      title: Text(l10n.selectLocaleTitle),
      contentPadding: EdgeInsets.zero,
      scrollable: true,
      content: Column(
        children: [
          RadioListTile(
            groupValue: selectedLocale,
            value: null,
            title: Text(l10n.localeSystem),
            onChanged: (value) {
              Navigator.of(context).pop<SelectLocaleDialogResult>((value,));
            },
            dense: true,
          ),
          const Divider(),
          for (final locale in KaitekiLocalizations.supportedLocales)
            _LocaleRadioListTile(
              selectedLocale: selectedLocale,
              locale: locale,
            ),
        ],
      ),
    );
  }
}

class _LocaleRadioListTile extends StatelessWidget {
  const _LocaleRadioListTile({
    required this.selectedLocale,
    required this.locale,
  });

  final Locale? selectedLocale;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    final monospaceTextStyle =
        Theme.of(context).ktkTextTheme?.monospaceTextStyle ??
            DefaultKaitekiTextTheme(context).monospaceTextStyle;
    final languageTag = Text(locale.toString(), style: monospaceTextStyle);
    final localeName = getLocaleName(locale);

    return RadioListTile(
      groupValue: selectedLocale,
      value: locale,
      title: localeName == null ? languageTag : Text(localeName),
      secondary: localeName == null ? null : languageTag,
      dense: true,
      onChanged: (value) {
        Navigator.of(context).pop<SelectLocaleDialogResult>((value,));
      },
    );
  }
}
