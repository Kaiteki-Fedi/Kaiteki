import 'package:flutter/material.dart';
import 'package:kaiteki/preferences/preference_container.dart';
import 'package:provider/provider.dart';

class CustomizationBasicPage extends StatefulWidget {
  CustomizationBasicPage({Key key}) : super(key: key);

  @override
  _CustomizationBasicPageState createState() => _CustomizationBasicPageState();
}

class _CustomizationBasicPageState extends State<CustomizationBasicPage> {
  @override
  Widget build(BuildContext context) {
    var preferences = Provider.of<PreferenceContainer>(context);

    return ListView(
      children: [
        ListTile(
          title: Text("Theme"),
          onTap: () async {
            var selection = await showDialog<ThemeMode>(
              context: context,
              builder: (BuildContext context) {
                return SimpleDialog(
                  title: const Text('Select theme'),
                  children: <Widget>[
                    for (var mode in ThemeMode.values)
                      SimpleDialogOption(
                        onPressed: () => Navigator.pop(context, mode),
                        child: Text(_themeToString(mode)),
                      ),
                  ],
                );
              },
            );

            if (selection == null) return;

            preferences.update((p) => p..theme = selection);
          },
          subtitle: Text(_themeToString(preferences.get().theme)),
        ),
      ],
    );
  }

  String _themeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return "Light";
        break;
      case ThemeMode.dark:
        return "Dark";
        break;
      case ThemeMode.system:
        return "System default";
        break;
      default:
        return mode.toString();
        break;
    }
  }
}
