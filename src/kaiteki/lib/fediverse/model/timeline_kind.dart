enum TimelineKind {
  /// The default timeline visible to the user.
  ///
  /// It has posts from the people that the user follows.
  home,

  /// Timeline that has the public posts of this instance.
  local,

  // Timeline that is weird
  social,

  /// The federated timeline that has all public posts received from all instances.
  federated,

  /// Timeline that lists all the direct messages that the user sent and received.
  directMessages,

  /// Timeline that has public posts from instances that this instance identifies with.
  ///
  /// Learn more: https://meta.akkoma.dev/t/akkoma-stable-2022-08-the-power-of-friendship-wahaha/46#the-bubble-timeline-3
  bubble,
}
