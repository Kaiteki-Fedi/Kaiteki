enum Visibility {
  /// This [Post] is federated to every instance.
  public,

  /// This [Post] is federated to every instance, but won't show up in public
  /// timelines.
  unlisted,

  /// This [Post] is federated only to followers of the author.
  followersOnly,

  /// This [Post] is federated only to mentioned users.
  direct
}
