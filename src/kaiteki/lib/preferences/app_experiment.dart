import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:kaiteki/preferences/app_preferences.dart";

enum AppExperiment {
  denseReactions(
    "Denser reactions",
    "Reduces the spacing between reactions in order to show more of them",
  ),
  feedback(
    "App Feedback",
    "Enable the feedback screen; currently unfunctional",
  ),
  chats("Chats"),
  navigationBarTheming(
    "Navigation bar theming",
    "Adjust the Android navigation bar to the current theme",
  );

  final String displayName;
  final String? description;

  const AppExperiment(this.displayName, [this.description]);

  Provider<bool> get provider => experimentsProvider(this);
}

final experimentsProvider = Provider.family<bool, AppExperiment>(
  (ref, e) => ref.watch(experiments.select((v) => v.value.contains(e))),
  dependencies: [experiments],
);
