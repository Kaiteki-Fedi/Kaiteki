/// Represents the post state for the signed-in user.
class PostState {
  /// Whether the user has liked (favorited) this post
  final bool favorited;

  /// Whether the user has repeated (boosted, retweeted, etc.) this post
  final bool repeated;

  final bool bookmarked;

  /// Whether this post has been pinned by its author.
  final bool pinned;

  /// Whether this post has been editd before.
  final bool edited;

  /// Whether this post is muted because of the current user.
  final bool muted;

  const PostState({
    this.favorited = false,
    this.repeated = false,
    this.bookmarked = false,
    this.pinned = false,
    this.edited = false,
    this.muted = false,
  });

  PostState copyWith({
    bool? favorited,
    bool? repeated,
    bool? bookmarked,
    bool? pinned,
    bool? edited,
    bool? muted,
  }) {
    return PostState(
      favorited: favorited ?? this.favorited,
      repeated: repeated ?? this.repeated,
      bookmarked: bookmarked ?? this.bookmarked,
      pinned: pinned ?? this.pinned,
      edited: edited ?? this.edited,
      muted: muted ?? this.muted,
    );
  }
}
