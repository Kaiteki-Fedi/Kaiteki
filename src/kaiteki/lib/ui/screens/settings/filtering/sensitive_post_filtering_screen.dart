import 'package:flutter/material.dart';
import 'package:kaiteki/preferences/preference_container.dart';
import 'package:provider/provider.dart';

class SensitivePostFilteringScreen extends StatefulWidget {
  SensitivePostFilteringScreen({Key? key}) : super(key: key);

  @override
  _SensitivePostFilteringScreenState createState() =>
      _SensitivePostFilteringScreenState();
}

class _SensitivePostFilteringScreenState
    extends State<SensitivePostFilteringScreen> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var preferences = Provider.of<PreferenceContainer>(context);
    var enabled = preferences.get().sensitivePostFilter.enabled;

    return Scaffold(
      appBar: AppBar(
        title: Text('Filter sensitive posts'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            tileColor: enabled ? theme.accentColor : theme.colorScheme.surface,
            activeColor: theme.colorScheme.onPrimary,
            title: Text(
              enabled ? 'On' : 'Off',
              style: enabled
                  ? TextStyle(color: theme.colorScheme.onPrimary)
                  : null,
            ),
            value: preferences.get().sensitivePostFilter.enabled,
            onChanged: (bool value) => preferences.update((p) {
              return p..sensitivePostFilter.enabled = value;
            }),
          ),
          CheckboxListTile(
            title: Text("Include posts marked as sensitive"),
            onChanged: (bool? value) => preferences.update((p) {
              return p
                ..sensitivePostFilter.filterPostsMarkedAsSensitive = value!;
            }),
            value: preferences
                .get()
                .sensitivePostFilter
                .filterPostsMarkedAsSensitive,
          ),
          CheckboxListTile(
            title: Text("Include posts with subject"),
            onChanged: (bool? value) => preferences.update((p) {
              return p..sensitivePostFilter.filterPostsWithSubject = value!;
            }),
            value: preferences.get().sensitivePostFilter.filterPostsWithSubject,
          ),
        ],
      ),
    );
  }
}
