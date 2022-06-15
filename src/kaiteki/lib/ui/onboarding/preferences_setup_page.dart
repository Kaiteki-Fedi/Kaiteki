import 'package:flutter/material.dart';
import 'package:kaiteki/fediverse/api_type.dart';

class PreferencesSetupPage extends StatefulWidget {
  const PreferencesSetupPage({Key? key}) : super(key: key);

  @override
  State<PreferencesSetupPage> createState() => _PreferencesSetupPageState();
}

class _PreferencesSetupPageState extends State<PreferencesSetupPage> {
  ApiType? selectedPreferencesSet;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        ListTile(title: Text("Work in progress")),
      ],
    );
  }
}
