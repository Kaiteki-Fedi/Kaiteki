import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';

class SensitivePostFilteringScreen extends ConsumerStatefulWidget {
  const SensitivePostFilteringScreen({Key? key}) : super(key: key);

  @override
  _SensitivePostFilteringScreenState createState() =>
      _SensitivePostFilteringScreenState();
}

class _SensitivePostFilteringScreenState
    extends ConsumerState<SensitivePostFilteringScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final preferences = ref.watch(preferenceProvider);
    final enabled = preferences.get().sensitivePostFilter.enabled;
    final l10n = context.getL10n();

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
            onChanged: (value) => preferences.update((p) {
              return p..sensitivePostFilter.enabled = value;
            }),
          ),
          CheckboxListTile(
            title: Text(l10n.filteringIncludeSensitive),
            onChanged: (value) => preferences.update((p) {
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
            onChanged: (value) => preferences.update((p) {
              return p..sensitivePostFilter.filterPostsWithSubject = value!;
            }),
            value: preferences.get().sensitivePostFilter.filterPostsWithSubject,
          ),
        ],
      ),
    );
  }
}
