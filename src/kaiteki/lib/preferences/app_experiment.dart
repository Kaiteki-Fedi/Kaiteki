enum AppExperiment {
  remoteUserFetching(
    "Fetch users from remote instances",
    "Allows querying the remote instance for user details, bypassing how up-to-date the current instance is.",
  ),
  timelineViews("Timeline views"),
  denseReactions(
    "Denser reactions",
    "Reduces the spacing between reactions in order to show more of them",
  ),
  newUserScreen(
    "New User Screen",
    "Use the new design of the user screen",
  ),
  feedback(
    "App Feedback",
    "Enable the feedback screen; currently unfunctional",
  );

  final String displayName;
  final String? description;

  const AppExperiment(this.displayName, [this.description]);
}
