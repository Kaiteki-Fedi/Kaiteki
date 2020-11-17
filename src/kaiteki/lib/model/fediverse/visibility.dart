enum Visibility {
  /// This [Post] is federated to every instance.
  Public,

  /// This [Post] is federated to every instance, but won't show up in public
  /// timelines.
  Unlisted,

  /// This [Post] is federated only to followers of the author.
  FollowersOnly,

  /// This [Post] is federated only to mentioned users.
  Direct
}