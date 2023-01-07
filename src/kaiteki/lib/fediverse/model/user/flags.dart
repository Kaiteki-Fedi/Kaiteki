class UserFlags {
  /// Whether the user is a bot.
  final bool isBot;

  /// Whether the [User] is part of the instance's administrators.
  final bool isAdministrator;

  /// Whether the [User] is part of the instance's moderators.
  final bool isModerator;

  /// Whether the [User] requires new followers to be approved (i.e. whether
  /// the account is "locked").
  final bool isApprovingFollowers;

  const UserFlags({
    required this.isBot,
    required this.isAdministrator,
    required this.isModerator,
    required this.isApprovingFollowers,
  });
}
