import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/app_preferences.dart" as preferences;
import "package:kaiteki/ui/settings/preference_switch_list_tile.dart";
import "package:kaiteki/ui/settings/settings_container.dart";
import "package:kaiteki/ui/settings/settings_section.dart";

class InteractionScreen extends ConsumerStatefulWidget {
  const InteractionScreen({super.key});

  @override
  ConsumerState<InteractionScreen> createState() => _InteractionScreenState();
}

class _InteractionScreenState extends ConsumerState<InteractionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Interactions"),
      ),
      body: SingleChildScrollView(
        child: SettingsContainer(
          child: Column(
            children: [
              // SettingsSection(
              //   title: const Text("Profiles"),
              //   children: [
              //     PreferenceSwitchListTile(
              //       title: const Text("Show following count"),
              //       provider: preferences.showFollowingCount,
              //     ),
              //     PreferenceSwitchListTile(
              //       title: const Text("Show follower count"),
              //       provider: preferences.showFollowerCount,
              //     ),
              //   ],
              // ),
              SettingsSection(
                title: const Text("Posts"),
                children: [
                  CheckboxListTile(
                    title: const Text("Show all interaction counts"),
                    value: getInteractionTristate(),
                    onChanged: (value) {
                      ref.read(preferences.showReplyCounts).value =
                          value ?? false;
                      ref.read(preferences.showFavoriteCounts).value =
                          value ?? false;
                      ref.read(preferences.showRepeatCounts).value =
                          value ?? false;
                    },
                    tristate: true,
                    secondary: const SizedBox(),
                  ),
                  CheckboxListTile(
                    title: const Text("Show reply counts"),
                    value: ref.watch(preferences.showReplyCounts).value,
                    onChanged: (value) {
                      if (value == null) return;
                      ref.read(preferences.showReplyCounts).value = value;
                    },
                    secondary: const Icon(Icons.reply_rounded),
                  ),
                  CheckboxListTile(
                    title: const Text("Show favorites counts"),
                    value: ref.watch(preferences.showFavoriteCounts).value,
                    onChanged: (value) {
                      if (value == null) return;
                      ref.read(preferences.showFavoriteCounts).value = value;
                    },
                    secondary: const Icon(Icons.star_rounded),
                  ),
                  CheckboxListTile(
                    title: const Text("Show repeat counts"),
                    value: ref.watch(preferences.showRepeatCounts).value,
                    onChanged: (value) {
                      if (value == null) return;
                      ref.read(preferences.showRepeatCounts).value = value;
                    },
                    secondary: const Icon(Icons.repeat_rounded),
                  ),
                ],
              ),
              SettingsSection(
                title: const Text("Reactions"),
                children: [
                  PreferenceSwitchListTile(
                    title: const Text("Show reactions"),
                    provider: preferences.showReactions,
                    secondary: const SizedBox(),
                  ),
                  PreferenceSwitchListTile(
                    title: const Text("Show reaction counts"),
                    provider: preferences.showReactionCounts,
                    enabled: ref.watch(preferences.showReactions).value,
                    secondary: const SizedBox(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool? getInteractionTristate() {
    final showReplyCounts = ref.watch(preferences.showReplyCounts).value;
    final showFavoriteCounts = ref.watch(preferences.showFavoriteCounts).value;
    final showRepeatCounts = ref.watch(preferences.showRepeatCounts).value;

    if (showReplyCounts && showFavoriteCounts && showRepeatCounts) {
      return true;
    } else if (!showReplyCounts && !showFavoriteCounts && !showRepeatCounts) {
      return false;
    } else {
      return null;
    }
  }
}
