import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kaiteki/preferences/preference_container.dart';
import 'package:kaiteki/preferences/sensitive_post_filtering_preferences.dart';
import 'package:provider/provider.dart';

class FilteringScreen extends StatelessWidget {
  const FilteringScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var container = Provider.of<PreferenceContainer>(context);
    var prefs = container.get();
    final l10n = AppLocalizations.of(context)!;

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
              onTap: () {
                Navigator.of(context)
                    .pushNamed('/settings/filtering/sensitivePosts');
              },
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const VerticalDivider(),
                  Switch(
                    value: prefs.sensitivePostFilter.enabled,
                    onChanged: (bool value) => container.update((p) {
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
    final l10n = AppLocalizations.of(context)!;

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
