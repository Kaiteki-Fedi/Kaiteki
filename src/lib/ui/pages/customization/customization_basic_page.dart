import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:kaiteki/api/model/pleroma/theme.dart';
import 'package:kaiteki/theming/app_theme_convertible.dart';
import 'package:kaiteki/theming/theme_container.dart';
import 'package:kaiteki/theming/theme_type.dart';
import 'package:kaiteki/ui/screens/settings/customization/pleroma_presets_screen.dart';
import 'package:kaiteki/ui/screens/settings/customization/pleroma_theme_screen.dart';
import 'package:kaiteki/ui/screens/settings/customization/app_background_screen.dart';
import 'package:mdi/mdi.dart';
import 'package:provider/provider.dart';

class CustomizationBasicPage extends StatefulWidget {
  CustomizationBasicPage({Key key}) : super(key: key);

  @override
  _CustomizationBasicPageState createState() => _CustomizationBasicPageState();
}

class _CustomizationBasicPageState extends State<CustomizationBasicPage> {
  @override
  Widget build(BuildContext context) {
    var themeContainer = Provider.of<ThemeContainer>(context);
    var type = getThemeType(themeContainer.rawTheme);

    return ListView(
      children: [
        ListTile(
          title: Text("Theme Type"),
          subtitle: Text(pleromaTheme == null ? "Material" : "Pleroma"),
          trailing: Icon(Mdi.chevronRight),
          enabled: false,
          // TODO: Add functionality
        ),
        ListTile(
          title: Text("App Background"),
          trailing: Icon(Mdi.chevronRight),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => AppBackgroundScreen()));
          },
        ),
        Divider(),
        //SwitchListTile(
        //  title: Text("Dark theme"),
        //  value: Theme.of(context).brightness == Brightness.dark,
        //),
        //ListTile(
        //  trailing: CircleAvatar(
        //    backgroundColor: Theme.of(context).primaryColor,
        //  ),
        //  title: Text("Primary color")
        //),
        //ListTile(
        //  trailing: CircleAvatar(
        //    backgroundColor: Theme.of(context).accentColor,
        //  ),
        //  title: Text("Accent color")
        //),
        ListTile(
          title: Text(pleromaTheme?.name ?? "Unnamed"),
          subtitle: Text("Current Theme"),
        ),
        ListTile(
          title: Text("Edit"),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PleromaThemeScreen())),
          trailing: Icon(Mdi.chevronRight),
        ),
        ListTile(
          title: Text("Import"),
          trailing: Icon(Mdi.chevronRight),
          onTap: importTheme,
        ),
        ListTile(
          title: Text("Choose Preset"),
          trailing: Icon(Mdi.chevronRight),
          onTap: () async {
            var theme = await Navigator.push<PleromaTheme>(context, MaterialPageRoute(builder: (_) => PleromaPresetsScreen()));

            if (theme == null) return;

            themeContainer.changePleromaTheme(theme);
          },
        ),
      ],
    );
  }

  void importTheme() async {
    var container = Provider.of<ThemeContainer>(context, listen: false);

    File file;

    try {
      file = await FilePicker.getFile(
        type: FileType.custom,
        allowedExtensions: ["json"],
      );
    } catch (e) {
      print("Failed to open file picker for theme import:\n$e");
      return;
    }

    if (file == null)
      return;

    var text = await file.readAsString();
    var json = jsonDecode(text);

    var theme = PleromaTheme.fromJson(json);
    container.changePleromaTheme(theme);

    //Scaffold.of(context).showSnackBar(SnackBar(
    //  content: Text("Theme imported."),
    //));
  }
}