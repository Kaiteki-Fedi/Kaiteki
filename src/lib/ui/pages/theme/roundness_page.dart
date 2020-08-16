import 'package:flutter/material.dart';
import 'package:kaiteki/theming/theme_container.dart';
import 'package:provider/provider.dart';

class RoundnessPage extends StatefulWidget {
  RoundnessPage({Key key}) : super(key: key);

  @override
  _RoundnessPageState createState() => _RoundnessPageState();
}

class _RoundnessPageState extends State<RoundnessPage> {
  @override
  Widget build(BuildContext context) {
    var container = Provider.of<ThemeContainer>(context);
    var theme = container.getCurrentPleromaTheme();
    var keys = theme.radii.keys;

    return ListView.builder(
      itemCount: keys.length,
      itemBuilder: (_, i) {
        var key = keys.elementAt(i);
        var value = theme.radii[key];
        return ListTile(
          title: Text(key),
          leading: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(value),
              color: Colors.white
            ),
            width: 24,
            height: 24,
          )
        );
      },
    );
  }
}