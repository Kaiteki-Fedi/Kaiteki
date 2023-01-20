import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/app_experiment.dart";

class ExperimentsScreen extends ConsumerWidget {
  const ExperimentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const availableExperiments = AppExperiment.values;
    final preferences = ref.read(preferencesProvider);
    final enabledExperiments = ref.watch(preferences.experiments).value;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Experiments"),
      ),
      body: ListView.separated(
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, i) {
          if (i == 0) {
            return Padding(
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
            );
          }

          i--;

          final experiment = availableExperiments[i];
          return SwitchListTile(
            value: enabledExperiments.contains(experiment),
            onChanged: (value) {
              final preferences = ref.read(preferencesProvider);
              final experimentsNotifier = ref.read(preferences.experiments);
              if (value) {
                experimentsNotifier.value = experimentsNotifier.value
                  ..add(experiment);
              } else {
                experimentsNotifier.value = experimentsNotifier.value
                  ..remove(experiment);
              }
            },
            title: Text(experiment.displayName),
            subtitle: experiment.description == null
                ? null
                : Text(experiment.description!),
          );
        },
        itemCount: availableExperiments.length + 1,
      ),
    );
  }
}
