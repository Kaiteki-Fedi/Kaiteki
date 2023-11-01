import "package:flutter/material.dart";

class PreferencesSetupPage extends StatefulWidget {
  const PreferencesSetupPage({super.key});

  @override
  State<PreferencesSetupPage> createState() => _PreferencesSetupPageState();
}

class _PreferencesSetupPageState extends State<PreferencesSetupPage> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(title: Text("Work in progress")),
      ],
    );
  }
}
