import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';

class CustomizationBasicPage extends ConsumerStatefulWidget {
  const CustomizationBasicPage({Key? key}) : super(key: key);

  @override
  _CustomizationBasicPageState createState() => _CustomizationBasicPageState();
}

class _CustomizationBasicPageState
    extends ConsumerState<CustomizationBasicPage> {
  @override
  Widget build(BuildContext context) {
    final prefs = ref.watch(preferenceProvider);
    final l10n = context.getL10n();

    return ListView(
      children: [
        ListTile(
          title: Text(l10n.theme),
          onTap: () async {
            final selection = await showDialog<ThemeMode>(
              context: context,
              builder: (context) {
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

            prefs.update((p) => p..theme = selection);
          },
          subtitle: Text(_themeToString(context, prefs.get().theme)),
        ),
      ],
    );
  }

  String _themeToString(BuildContext context, ThemeMode mode) {
    final l10n = context.getL10n();

    switch (mode) {
      case ThemeMode.light:
        return l10n.themeLight;

      case ThemeMode.dark:
        return l10n.themeDark;

      case ThemeMode.system:
        return l10n.themeSystem;
    }
  }
}
