import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/theme_preferences.dart";
import "package:kaiteki/ui/settings/preference_switch_list_tile.dart";
import "package:kaiteki/ui/settings/settings_container.dart";
import "package:kaiteki/ui/settings/settings_section.dart";
import "package:kaiteki/ui/shared/posts/post_widget.dart";
import "package:kaiteki_core/model.dart";

final _example = examplePost.copyWith(
  author: examplePost.author
      .copyWith(flags: const UserFlags(isAdministrator: true)),
  attachments: [
    Attachment(
      previewUrl: Uri.parse(
        "https://img3.gelbooru.com//samples/35/d0/sample_35d062999d7da01dba7e93899ea72a38.jpg",
      ),
      url: Uri.parse(
        "https://img3.gelbooru.com/images/35/d0/35d062999d7da01dba7e93899ea72a38.jpg",
      ),
      type: AttachmentType.image,
    ),
    Attachment(
      previewUrl: null,
      url: Uri.parse("https://example.org"),
    ),
  ],
);

class PostLayoutSettingsScreen extends StatelessWidget {
  const PostLayoutSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Post appearance")),
      body: SingleChildScrollView(
        child: SettingsContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16.0),
              SettingsSection(
                children: [
                  Consumer(
                    builder: (context, ref, _) {
                      final theme = Theme.of(context);
                      return Theme(
                        data: ref.watch(usePostCards).value
                            ? theme
                            : theme.copyWith(
                                cardTheme: CardTheme.of(context).copyWith(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    side: BorderSide(
                                      color: theme.colorScheme.outline,
                                    ),
                                  ),
                                ),
                              ),
                        child: PostWidget(
                          _example,
                          layout: ref.watch(postLayout).value,
                        ),
                      );
                    },
                  ),
                ],
              ),
              SettingsSection(
                children: [

                  Consumer(
                    builder: (context, ref, _) {
                      return ListTile(
                        title: const Text("Layout"),
                        subtitle: Text(ref.watch(postLayout).value.name),
                      );
                    },
                  ),
                  PreferenceSwitchListTile(
                    provider: cropAttachments,
                    title: const Text("Crop attachments"),
                  ),
                  PreferenceSwitchListTile(
                    provider: usePostCards,
                    title: const Text("Use cards"),
                  ),
                  PreferenceSwitchListTile(
                    provider: showUserBadges,
                    title: const Text("Show user badges"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
