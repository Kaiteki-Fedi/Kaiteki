class UserFlags {
  /// Whether the [User] is part of the instance's administrators.
  final bool? isAdministrator;

  /// Whether the [User] is part of the instance's moderators.
  final bool? isModerator;

  /// Whether the [User] requires new followers to be approved (i.e. whether
  /// the account is "locked").
  final bool? isApprovingFollowers;

  const UserFlags({
    this.isAdministrator,
    this.isModerator,
    this.isApprovingFollowers,
  });
}
