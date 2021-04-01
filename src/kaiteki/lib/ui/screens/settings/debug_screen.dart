import 'package:flutter/material.dart';
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
