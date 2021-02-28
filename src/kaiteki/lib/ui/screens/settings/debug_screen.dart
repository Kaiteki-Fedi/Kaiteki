import 'package:flutter/material.dart';
import 'package:logger_flutter/logger_flutter.dart';
import 'package:mdi/mdi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DebugScreen extends StatefulWidget {
  DebugScreen({Key key}) : super(key: key);

  @override
  _DebugScreenState createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
  @override
  Widget build(BuildContext _) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Debug and Maintenance"),
      ),
      body: Column(
        children: [
          Material(
            elevation: 6,
            color: Colors.red,
            child: ListTile(
              title: Text("Please proceed here with caution as some settings might have unintended behavior or delete your user settings."),
            ),
          ),
          ListTile(
            leading: Icon(Mdi.textBox),
            title: Text("Open log console"),
            onTap: () {
              return Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
                var dark = Theme.of(context).brightness == Brightness.dark;
                return LogConsole(dark: dark, showCloseButton: true);
              }));
            },
          ),
          ListTile(
            leading: Icon(Icons.delete),
            title: Text("Clear shared preferences"),
            subtitle: Text("The shared preferences contain your tokens alongside your user preferences. A restart of the app is recommended to make the changes take effect."),
            onTap: () async {
              var instance = await SharedPreferences.getInstance();
              assert(await instance.clear(), "clear failed");
            },
          )
        ],
      ),
    );
  }
}