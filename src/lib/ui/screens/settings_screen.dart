import 'package:flutter/material.dart';
import 'package:kaiteki/ui/screens/settings/customization_settings_screen.dart';
import 'package:kaiteki/ui/widgets/separator_text.dart';
import 'package:mdi/mdi.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Mdi.wrench),
            title: Text("General"),
            enabled: false,
          ),
          ListTile(
            leading: Icon(Mdi.account),
            title: Text("Profile"),
            enabled: false,
          ),
          ListTile(
            leading: Icon(Mdi.lock),
            title: Text("Security"),
            enabled: false,
          ),
          ListTile(
            leading: Icon(Mdi.filter),
            title: Text("Filtering"),
            enabled: false,
          ),
          ListTile(
            leading: Icon(Mdi.bell),
            title: Text("Notifications"),
            enabled: false,
          ),
          ListTile(
            leading: Icon(Mdi.download),
            title: Text("Data Import / Export"),
            enabled: false,
          ),
          ListTile(
            leading: Icon(Mdi.eyeOff),
            title: Text("Mutes and Blocks"),
            enabled: false,
          ),
          Divider(),
          SeparatorText("Kaiteki Settings"),
          ListTile(
            leading: Icon(Mdi.brush),
            title: Text("Theme"),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CustomizationSettingsScreen()))
          ),
          ListTile(
            leading: Icon(Mdi.tab),
            title: Text("Tabs"),
            enabled: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Mdi.information),
            title: Text("About"),
            onTap: () => Navigator.pushNamed(context, "/about")
          ),
          ListTile(
            leading: Icon(Mdi.bug),
            title: Text("Debug and maintenance"),
            onTap: () => Navigator.pushNamed(context, "/debug")
          )
        ],
      )
    );
  }
}
