import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kaiteki/preferences/preference_container.dart';
import 'package:provider/provider.dart';

class SensitivePostFilteringScreen extends StatefulWidget {
  const SensitivePostFilteringScreen({Key? key}) : super(key: key);

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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsHideSensitivePosts)),
      body: ListView(
        children: [
          SwitchListTile(
            tileColor: enabled
                ? theme.colorScheme.secondary
                : theme.colorScheme.surface,
            activeColor: theme.colorScheme.onPrimary,
            title: Text(
              enabled ? l10n.switchListTileTextOn : l10n.switchListTileTextOff,
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
            title: Text(l10n.filteringIncludeSensitive),
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
            title: Text(l10n.filteringIncludeSubject),
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
