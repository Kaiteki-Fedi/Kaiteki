import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/preferences/sensitive_post_filtering_preferences.dart';

class FilteringScreen extends ConsumerWidget {
  const FilteringScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefContainer = ref.watch(preferenceProvider);
    final prefs = prefContainer.get();
    final l10n = context.getL10n();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsFiltering)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: Text(l10n.settingsHideSensitivePosts),
              subtitle: Text(
                getSensitiveMediaSubtitle(context, prefs.sensitivePostFilter),
              ),
              onTap: () => context.push('/settings/filtering/sensitivePosts'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const VerticalDivider(),
                  Switch(
                    value: prefs.sensitivePostFilter.enabled,
                    onChanged: (value) => prefContainer.update((p) {
                      return p..sensitivePostFilter.enabled = value;
                    }),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String getSensitiveMediaSubtitle(
    BuildContext context,
    SensitivePostFilteringPreferences prefs,
  ) {
    final l10n = context.getL10n();

    if (!prefs.enabled) {
      return l10n.settingsDisabled;
    }

    final words = [
      if (prefs.filterPostsMarkedAsSensitive) l10n.settingsSensitivePosts,
      if (prefs.filterPostsWithSubject) l10n.settingsSubjectPosts,
    ];

    return words.join(", ");
  }
}
