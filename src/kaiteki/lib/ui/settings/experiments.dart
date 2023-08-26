import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/app_experiment.dart";
import "package:kaiteki/preferences/app_preferences.dart" as preferences;
import "package:kaiteki/ui/settings/settings_container.dart";
import "package:kaiteki/ui/settings/settings_section.dart";

class ExperimentsScreen extends ConsumerWidget {
  const ExperimentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const availableExperiments = AppExperiment.values;
    final enabledExperiments = ref.watch(preferences.experiments).value;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.settingsExperiments),
      ),
      body: SingleChildScrollView(
        child: SettingsContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: Theme.of(context).colorScheme.secondaryContainer,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "These settings are experimental, yadda yadda yadda, still work in progress, you know the spiel.",
                    ),
                  ),
                ),
              ),
              SettingsSection(
                children: [
                  for (final experiment in availableExperiments)
                    SwitchListTile(
                      value: enabledExperiments.contains(experiment),
                      onChanged: (value) {
                        final notifier = ref.read(preferences.experiments);
                        final experiments = notifier.value.toList();
                        if (value) {
                          notifier.value = experiments..add(experiment);
                        } else {
                          notifier.value = experiments..remove(experiment);
                        }
                      },
                      title: Text(experiment.displayName),
                      subtitle: experiment.description == null
                          ? null
                          : Text(experiment.description!),
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
