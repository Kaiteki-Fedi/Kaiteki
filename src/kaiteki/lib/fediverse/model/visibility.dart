enum Visibility {
  /// This [Post] federates to every instance.
  public,

  /// This [Post] is not visible in public timelines.
  unlisted,

  /// This [Post] is only visible to author's followers.
  followersOnly,

  /// This [Post] is only visible to mentioned users.
  direct,

  /// This [Post] is only visible to the author's circle.
  circle,

  /// This [Post] does not federate.
  local,
}
