/// Represents the post state for the signed-in user.
class PostState {
  /// Whether the user has liked (favorited) this post
  final bool favorited;

  /// Whether the user has repeated (boosted, retweeted, etc.) this post
  final bool repeated;

  final bool bookmarked;

  final bool pinned;

  const PostState({
    this.favorited = false,
    this.repeated = false,
    this.bookmarked = false,
    this.pinned = false,
  });

  PostState copyWith({
    bool? favorited,
    bool? repeated,
    bool? bookmarked,
    bool? pinned,
  }) {
    return PostState(
      favorited: favorited ?? this.favorited,
      repeated: repeated ?? this.repeated,
      bookmarked: bookmarked ?? this.bookmarked,
      pinned: pinned ?? this.pinned,
    );
  }
}
