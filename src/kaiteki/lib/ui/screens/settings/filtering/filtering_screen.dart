import 'package:flutter/material.dart';
import 'package:kaiteki/preferences/preference_container.dart';
import 'package:kaiteki/preferences/sensitive_post_filtering_preferences.dart';
import 'package:provider/provider.dart';

class FilteringScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var container = Provider.of<PreferenceContainer>(context);
    var prefs = container.get();

    return Scaffold(
      appBar: AppBar(title: const Text("Filtering")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: const Text("Hide sensitive posts"),
              subtitle: Text(
                getSensitiveMediaSubtitle(prefs.sensitivePostFilter),
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

  String getSensitiveMediaSubtitle(SensitivePostFilteringPreferences prefs) {
    if (!prefs.enabled) {
      return "Disabled";
    }

    var words = [];

    if (prefs.filterPostsMarkedAsSensitive) words.add("Sensitive posts");
    if (prefs.filterPostsWithSubject) words.add("Posts with subjects");

    return words.join(", ");
  }
}
