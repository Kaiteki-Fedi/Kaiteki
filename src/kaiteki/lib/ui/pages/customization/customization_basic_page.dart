import 'dart:convert';

import 'package:fediverse_objects/pleroma/theme.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:kaiteki/theming/app_theme_source.dart';
import 'package:kaiteki/theming/material_app_theme.dart';
import 'package:kaiteki/theming/pleroma_app_theme.dart';
import 'package:kaiteki/theming/theme_container.dart';
import 'package:kaiteki/theming/theme_type.dart';
import 'package:kaiteki/ui/screens/settings/customization/app_background_screen.dart';
import 'package:kaiteki/ui/screens/settings/customization/pleroma_presets_screen.dart';
import 'package:kaiteki/ui/screens/settings/customization/pleroma_theme_screen.dart';
import 'package:kaiteki/utils/utils.dart';
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
    var type = getThemeType(themeContainer.source);

    return ListView(
      children: [
        ListTile(
          title: Text("Theme Type"),
          subtitle: Text(type == ThemeType.Material ? "Material" : "Pleroma"),
          trailing: Icon(Mdi.chevronRight),
          enabled: false,
          // TODO Add functionality
        ),
        ListTile(
          title: Text("App Background"),
          trailing: Icon(Mdi.chevronRight),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => AppBackgroundScreen()));
          },
        ),
        Divider(),
        getPart(context, type, themeContainer),
      ],
    );
  }

  ThemeType getThemeType(AppThemeSource source) {
    if (source is PleromaAppTheme) return ThemeType.Pleroma;
    if (source is MaterialAppTheme) return ThemeType.Material;
    return null;
  }

  Widget getPart(
      BuildContext context, ThemeType type, ThemeContainer container) {
    switch (type) {
      case ThemeType.Material:
        {
          var theme = Theme.of(context);
          return Column(
            children: [
              SwitchListTile(
                title: Text("Dark theme"),
                value: theme.brightness == Brightness.dark,
                onChanged: null,
              ),
              ListTile(
                  trailing: Container(
                    decoration: getBorderDecoration(theme.canvasColor),
                    child: CircleAvatar(
                      backgroundColor: theme.canvasColor,
                    ),
                  ),
                  title: Text("Background color")),
              ListTile(
                  trailing: Container(
                    decoration: getBorderDecoration(theme.primaryColor),
                    child: CircleAvatar(
                      backgroundColor: theme.primaryColor,
                    ),
                  ),
                  title: Text("Primary color")),
              ListTile(
                  trailing: Container(
                    decoration: getBorderDecoration(theme.accentColor),
                    child: CircleAvatar(
                      backgroundColor: theme.accentColor,
                    ),
                  ),
                  title: Text("Accent color")),
            ],
          );
        }
      case ThemeType.Pleroma:
        {
          var pleromaTheme = container.source as PleromaTheme;
          return Column(
            children: [
              // ListTile(
              //   title: Text(pleromaTheme?.name ?? "Unnamed"),
              //   subtitle: Text("Current Theme"),
              // ),
              ListTile(
                title: Text("Edit"),
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => PleromaThemeScreen())),
                trailing: Icon(Mdi.chevronRight),
                enabled: pleromaTheme != null,
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
                  var theme = await Navigator.push<PleromaTheme>(
                      context,
                      MaterialPageRoute(
                          builder: (_) => PleromaPresetsScreen()));

                  if (theme == null) return;

                  container.source = PleromaAppTheme(theme);
                },
              ),
            ],
          );
        }
      default:
        throw "Out of range";
    }
  }

  BoxDecoration getBorderDecoration(Color color) {
    var borderColor = Utils.getReadableForeground(color);
    return BoxDecoration(
      border: Border.all(
        color: Color.lerp(borderColor, color, 1 - .25),
        width: 2,
      ),
      borderRadius: BorderRadius.circular(64),
    );
  }

  void importTheme() async {
    var container = Provider.of<ThemeContainer>(context, listen: false);

    PlatformFile file;

    try {
      var result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ["json"],
      );

      if (result == null) return;

      file = result.files.single;
    } catch (e) {
      print("Failed to open file picker for theme import:\n$e");
      return;
    }

    var text = utf8.decode(file.bytes);
    var json = jsonDecode(text);

    container.source = PleromaAppTheme(PleromaTheme.fromJson(json));

    //Scaffold.of(context).showSnackBar(SnackBar(
    //  content: Text("Theme imported."),
    //));
  }
}
