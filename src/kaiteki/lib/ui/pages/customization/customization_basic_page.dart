import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kaiteki/preferences/preference_container.dart';
import 'package:provider/provider.dart';

class CustomizationBasicPage extends StatefulWidget {
  const CustomizationBasicPage({Key? key}) : super(key: key);

  @override
  _CustomizationBasicPageState createState() => _CustomizationBasicPageState();
}

class _CustomizationBasicPageState extends State<CustomizationBasicPage> {
  @override
  Widget build(BuildContext context) {
    final preferences = Provider.of<PreferenceContainer>(context);
    final l10n = AppLocalizations.of(context)!;

    return ListView(
      children: [
        ListTile(
          title: Text(l10n.theme),
          onTap: () async {
            var selection = await showDialog<ThemeMode>(
              context: context,
              builder: (BuildContext context) {
                return SimpleDialog(
                  title: Text(l10n.selectThemeTitle),
                  children: <Widget>[
                    for (var mode in ThemeMode.values)
                      SimpleDialogOption(
                        onPressed: () => Navigator.pop(context, mode),
                        child: Text(_themeToString(context, mode)),
                      ),
                  ],
                );
              },
            );

            if (selection == null) return;

            preferences.update((p) => p..theme = selection);
          },
          subtitle: Text(_themeToString(context, preferences.get().theme)),
        ),
      ],
    );
  }

  String _themeToString(BuildContext context, ThemeMode mode) {
    final l10n = AppLocalizations.of(context)!;

    switch (mode) {
      case ThemeMode.light:
        return l10n.themeLight;

      case ThemeMode.dark:
        return l10n.themeDark;

      case ThemeMode.system:
        return l10n.themeSystem;

      default:
        return mode.toString();
    }
  }
}
