import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:kaiteki/theming/theme_container.dart';
import 'package:provider/provider.dart';

class AppBackgroundScreen extends StatefulWidget {
  AppBackgroundScreen({Key key}) : super(key: key);

  @override
  _AppBackgroundScreenState createState() => _AppBackgroundScreenState();
}

class _AppBackgroundScreenState extends State<AppBackgroundScreen> {
  @override
  Widget build(BuildContext context) {
    var container = Provider.of<ThemeContainer>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Background")
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 8),
        children: [
          ListTile(
            title: Text("You can set an image to display behind transparent backgrounds.\nTransparent backgrounds might cause minor flickering when transitioning between screens."),
          ),
          Divider(),
          ListTile(
            title: Text("Select background"),
            onTap: () async {
              File file;

              try {
                file = await FilePicker.getFile(type: FileType.image);
              } catch (e) {
                print("Failed to open file picker for theme import:\n$e");
                return;
              }

              if (file == null)
                return;

              var image = Image.file(file).image;
              container.setBackground(image);
            },
          ),
          ListTile(
            title: Text("Reset"),
            onTap: () => container.setBackground(null),
          ),
          Divider(),
          ListTile(
            title: Text("Opacity"),
          ),
          Slider(
            value: container?.getCurrentPleromaTheme()?.getOpacity("bg") ?? 0,
          ),
        ],
      )
    );
  }
}