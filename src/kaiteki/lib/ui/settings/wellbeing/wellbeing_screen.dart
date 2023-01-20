import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/app_preferences.dart";

class WellbeingScreen extends StatelessWidget {
  const WellbeingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wellbeing"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            ContentWarningBehaviorListTile(),
          ],
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
    final preferences = ref.read(preferencesProvider);
    final state = ref.watch(preferences.cwBehavior).value;

    Widget subtitle;

    switch (state) {
      case ContentWarningBehavior.collapse:
        subtitle = const Text("Collapse post");
        break;
      case ContentWarningBehavior.automatic:
        subtitle = const Text("Automatic");
        break;
      case ContentWarningBehavior.expanded:
        subtitle = const Text("Expand post");
        break;
    }

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

    final preferences = ref.read(preferencesProvider);
    ref.read(preferences.cwBehavior).value = choice;
  }
}

class ContentWarningBehaviorDialog extends ConsumerWidget {
  const ContentWarningBehaviorDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferences = ref.read(preferencesProvider);
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
    switch (behavior) {
      case ContentWarningBehavior.collapse:
        return const Text("Collapse");

      case ContentWarningBehavior.automatic:
        return const Text("Automatic");

      case ContentWarningBehavior.expanded:
        return const Text("Expanded");
    }
  }

  Widget _buildSubtitle(ContentWarningBehavior behavior) {
    switch (behavior) {
      case ContentWarningBehavior.collapse:
        return const Text(
          "Posts with a content warning are always collapsed",
        );

      case ContentWarningBehavior.automatic:
        return const Text(
          "Posts will be collapsed if their content warning contains sensitive words",
        );

      case ContentWarningBehavior.expanded:
        return const Text(
          "Posts are always expanded. Content warnings are being treated as subjects.",
        );
    }
  }
}
