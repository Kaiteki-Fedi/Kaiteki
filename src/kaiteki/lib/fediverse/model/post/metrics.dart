class PostMetrics {
  /// How many users have liked this post
  final int likeCount;

  /// How many users have repeated (boosted, retweeted, etc.) this post
  final int repeatCount;

  /// How many users have replied to this post
  final int replyCount;

  const PostMetrics({
    this.likeCount = 0,
    this.repeatCount = 0,
    this.replyCount = 0,
  });
}
