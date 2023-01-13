import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/app_experiment.dart";

class ExperimentsScreen extends ConsumerWidget {
  const ExperimentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const experiments = AppExperiment.values;
    final enabledExperiments = ref.watch(
      preferencesProvider.select((p) => p.enabledExperiments),
    );
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

          final experiment = experiments[i];
          return SwitchListTile(
            value: enabledExperiments.contains(experiment),
            onChanged: (value) {
              final preferences = ref.read(preferencesProvider);
              if (value) {
                preferences.enableExperiment(experiment);
              } else {
                preferences.disableExperiment(experiment);
              }
            },
            title: Text(experiment.displayName),
            subtitle: experiment.description == null
                ? null
                : Text(experiment.description!),
          );
        },
        itemCount: experiments.length + 1,
      ),
    );
  }
}
