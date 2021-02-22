ListTile(
  title: Text("App Background"),
  trailing: Icon(Mdi.chevronRight),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AppBackgroundScreen()),
    );
  },
),

case ThemeType.Pleroma: {
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

Widget getPart(
    BuildContext context,
    ThemeType type,
    ThemeContainer container,
  ) {
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
    }
  }

  ThemeType getThemeType(AppThemeSource source) {
    if (source is MaterialAppTheme) return ThemeType.Material;
    return null;
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