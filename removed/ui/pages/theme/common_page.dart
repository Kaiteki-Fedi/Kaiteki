import 'package:flutter/material.dart';
import 'package:fediverse_objects/pleroma/theme.dart';
import 'package:kaiteki/theming/theme_container.dart';
import 'package:provider/provider.dart';
import 'package:supercharged/supercharged.dart';

class CommonPage extends StatefulWidget {
  CommonPage({Key key}) : super(key: key);

  @override
  _CommonPageState createState() => _CommonPageState();
}

class _CommonPageState extends State<CommonPage> {
  @override
  Widget build(BuildContext context) {
    var container = Provider.of<ThemeContainer>(context);
    var theme = container.source as PleromaTheme;
    var keys = theme.colors.keys;

    return ListView.builder(
      itemCount: keys.length,
      itemBuilder: (_, i) {
        var key = keys.elementAt(i);
        var value = theme.colors[key];
        return ListTile(
          title: Text(key),
          leading: CircleAvatar(
            backgroundColor: value.toColor(),
          ),
        );
      },
    );
  }
}
