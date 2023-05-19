import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:kaiteki/preferences/app_preferences.dart";

enum AppExperiment {
  remoteUserFetching(
    "Fetch users from remote instances",
    "Allows querying the remote instance for user details",
  ),
  timelineViews("Layouts"),
  denseReactions(
    "Denser reactions",
    "Reduces the spacing between reactions in order to show more of them",
  ),
  feedback(
    "App Feedback",
    "Enable the feedback screen; currently unfunctional",
  ),
  chats("Chats"),
  instanceVetting(
    "Instance vetting",
    "See the information of an instance at a glance",
  ),
  userSignatures(
    "User signatures",
    "Show the user's bio under their posts",
  ),
  navigationBarTheming(
    "Navigation bar theming",
    "Adjust the Android navigation bar to the current theme",
  ),
  articleView(
    "Article view",
    "Read posts like articles",
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
