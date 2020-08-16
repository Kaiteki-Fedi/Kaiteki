import 'package:flutter/material.dart';
import 'package:kaiteki/app_preferences.dart';
import 'package:mdi/mdi.dart';
import 'package:provider/provider.dart';

class CustomizationAdvancedPage extends StatefulWidget {
  CustomizationAdvancedPage({Key key}) : super(key: key);

  @override
  _CustomizationAdvancedPageState createState() =>
      _CustomizationAdvancedPageState();
}

class _CustomizationAdvancedPageState extends State<CustomizationAdvancedPage> {
  @override
  Widget build(BuildContext context) {
    var preferences = Provider.of<AppPreferences>(context);

    return ListView(
      children: [
        ListTile(
          title: Text("This page contains fine tuned settings to customize the app to the last detail."),
        ),
        SwitchListTile(
          title: Text("Center title"),
          value: Theme.of(context).appBarTheme?.centerTitle ?? false,
        ),
        ListTile(
          title: Text("Submit button location"),
          subtitle: Text(preferences.submitButtonLocation.toString()),
          trailing: IconButton(
            icon: Icon(Mdi.helpCircle),
          ),
        )
      ],
    );
  }
}