import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/fediverse/model/mock_data.dart";
import "package:kaiteki/fediverse/model/model.dart";
import "package:kaiteki/preferences/theme_preferences.dart";
import "package:kaiteki/ui/settings/preference_switch_list_tile.dart";
import "package:kaiteki/ui/settings/settings_container.dart";
import "package:kaiteki/ui/settings/settings_section.dart";
import "package:kaiteki/ui/shared/posts/post_widget.dart";

class PostLayoutSettingsScreen extends StatelessWidget {
  const PostLayoutSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Post layout")),
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
                      return PostWidget(
                        examplePost.copyWith(
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
                        ),
                        layout: ref.watch(useWidePostLayout).value
                            ? PostWidgetLayout.wide
                            : PostWidgetLayout.normal,
                      );
                    },
                  ),
                ],
              ),
              SettingsSection(
                children: [
                  PreferenceSwitchListTile(
                    provider: useWidePostLayout,
                    title: const Text("Wide layout"),
                  ),
                  // PreferenceSwitchListTile(
                  //   provider: useFullWidthAttachments,
                  //   title: const Text("Full-width attachments"),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
