enum AppExperiment {
  remoteUserFetching(
    "Fetch users from remote instances",
    "Allows querying the remote instance for user details, bypassing how up-to-date the current instance is.",
  );

  final String displayName;
  final String? description;

  const AppExperiment(this.displayName, [this.description]);
}
