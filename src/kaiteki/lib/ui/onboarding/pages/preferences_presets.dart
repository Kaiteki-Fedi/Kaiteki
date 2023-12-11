import "package:flutter/material.dart" hide BackButton;
import "package:go_router/go_router.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/app_preferences.dart";
import "package:kaiteki/preferences/theme_preferences.dart";
import "package:kaiteki/ui/onboarding/widgets/back_button.dart";
import "package:kaiteki/utils/extensions.dart";

class PreferencesSetupPage extends StatefulWidget {
  const PreferencesSetupPage({super.key});

  @override
  State<PreferencesSetupPage> createState() => _PreferencesSetupPageState();
}

class _PreferencesSetupPageState extends State<PreferencesSetupPage> {
  // bool _queerPreset = false;
  bool _wellbeingPreset = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Make yourself at home",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Text(
            "Use the following presets to get started. You can always change them later.",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card.outlined(
                  //   clipBehavior: Clip.antiAlias,
                  //   child: CheckboxListTile(
                  //     title: Text("Settings useful for queer people"),
                  //     subtitle: Text("Show pronouns"),
                  //     value: _queerPreset,
                  //     onChanged: (value) =>
                  //         setState(() => _queerPreset = value ?? false),
                  //   ),
                  // ),
                  // const SizedBox(height: 8),
                  Card.outlined(
                    clipBehavior: Clip.antiAlias,
                    child: CheckboxListTile(
                      title: Text("Settings useful for wellbeing"),
                      subtitle: Text(
                        "Use less attention-grabbing colors, hide numbers",
                      ),
                      value: _wellbeingPreset,
                      onChanged: (value) =>
                          setState(() => _wellbeingPreset = value ?? false),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BackButton(),
              const Spacer(),
              Directionality(
                textDirection: Directionality.of(context).inverted,
                child: FilledButton.icon(
                  onPressed: () {
                    final container = ProviderScope.containerOf(context);

                    // TODO(Craftplacer): Set pronouns when implemented
                    // if (_queerPreset) {
                    // }

                    if (_wellbeingPreset) {
                      container.read(useNaturalBadgeColors).value = true;
                      container.read(hidePostMetrics).value = true;
                    }

                    context.push("/onboarding/theme");
                  },
                  style: FilledButton.styleFrom(
                    visualDensity: VisualDensity.standard,
                  ),
                  icon: const Icon(Icons.chevron_left_rounded),
                  label: Text(context.l10n.nextButtonLabel),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
