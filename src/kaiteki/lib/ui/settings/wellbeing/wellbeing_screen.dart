import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/app_preferences.dart" as preferences;
import "package:kaiteki/preferences/content_warning_behavior.dart";
import "package:kaiteki/preferences/theme_preferences.dart" as preferences;
import "package:kaiteki/ui/settings/preference_switch_list_tile.dart";
import "package:kaiteki/ui/settings/settings_container.dart";
import "package:kaiteki/ui/settings/settings_section.dart";

class WellbeingSettingsScreen extends StatelessWidget {
  const WellbeingSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wellbeing"),
      ),
      body: SingleChildScrollView(
        child: SettingsContainer(
          child: Column(
            children: [
              SettingsSection(
                children: [
                  ListTile(
                    leading: const Icon(Icons.pin_rounded),
                    title: const Text("Interactions"),
                    onTap: () =>
                        context.push("/settings/wellbeing/interactions"),
                  ),
                  const ContentWarningBehaviorListTile(),
                ],
              ),
              SettingsSection(
                title: const Text("Badges"),
                children: [
                  PreferenceSwitchListTile(
                    secondary: const Icon(Icons.looks_one_rounded),
                    title: const Text("Use neutral badge colors"),
                    provider: preferences.useNaturalBadgeColors,
                  ),
                  PreferenceSwitchListTile(
                    secondary: const SizedBox(),
                    title: const Text("Show badge numbers"),
                    provider: preferences.showBadgeNumbers,
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

class ContentWarningBehaviorListTile extends ConsumerWidget {
  const ContentWarningBehaviorListTile({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(preferences.cwBehavior).value;
    final subtitle = switch (state) {
      ContentWarningBehavior.collapse => const Text("Collapse post"),
      ContentWarningBehavior.automatic => const Text("Automatic"),
      ContentWarningBehavior.expanded => const Text("Expand post")
    };

    return ListTile(
      leading: const Icon(Icons.warning_rounded),
      title: const Text("Content warning behavior"),
      subtitle: subtitle,
      onTap: () => _onTap(context, ref),
    );
  }

  Future<void> _onTap(BuildContext context, WidgetRef ref) async {
    final choice = await showDialog<ContentWarningBehavior>(
      context: context,
      builder: (context) => const ContentWarningBehaviorDialog(),
    );

    if (choice == null) return;

    ref.read(preferences.cwBehavior).value = choice;
  }
}

class ContentWarningBehaviorDialog extends ConsumerWidget {
  const ContentWarningBehaviorDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(preferences.cwBehavior).value;

    return SimpleDialog(
      title: const Text("Content warning behavior"),
      children: ListTile.divideTiles(
        context: context,
        tiles: [
          for (final option in ContentWarningBehavior.values)
            RadioListTile(
              title: _buildTitle(option),
              subtitle: _buildSubtitle(option),
              onChanged: Navigator.of(context).maybePop,
              groupValue: state,
              value: option,
            ),
        ],
      ).toList(),
    );
  }

  Widget _buildTitle(ContentWarningBehavior behavior) {
    return switch (behavior) {
      ContentWarningBehavior.collapse => const Text("Collapse"),
      ContentWarningBehavior.automatic => const Text("Automatic"),
      ContentWarningBehavior.expanded => const Text("Expanded")
    };
  }

  Widget _buildSubtitle(ContentWarningBehavior behavior) {
    return Text(
      switch (behavior) {
        ContentWarningBehavior.collapse =>
          "Posts with a content warning are always collapsed",
        ContentWarningBehavior.automatic =>
          "Posts will be collapsed if their content warning contains sensitive words",
        ContentWarningBehavior.expanded =>
          "Posts are always expanded. Content warnings are being treated as subjects.",
      },
    );
  }
}
