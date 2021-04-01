import 'package:flutter/material.dart';
import 'package:logger_flutter/logger_flutter.dart';
import 'package:mdi/mdi.dart';

class DebugScreen extends StatefulWidget {
  DebugScreen({Key? key}) : super(key: key);

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
              leading: Icon(Mdi.alert),
              title: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Please proceed here with caution as some settings might have unintended behavior or delete your user settings.',
                ),
              ),
              dense: true,
            ),
          ),
          ListTile(
            leading: Icon(Mdi.textBox),
            title: Text("Open log console"),
            onTap: () {
              Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
                var dark = Theme.of(context).brightness == Brightness.dark;
                return LogConsole(dark: dark, showCloseButton: true);
              }));
            },
          ),
          ListTile(
            leading: Icon(Mdi.wrench),
            title: Text("Manage shared preferences"),
            onTap: () async {
              Navigator.of(context).pushNamed('/settings/debug/preferences');
            },
          ),
        ],
      ),
    );
  }
}
