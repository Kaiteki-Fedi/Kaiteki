class TimelineQuery<T> {
  final T? sinceId;
  final T? untilId;

  const TimelineQuery({this.sinceId, this.untilId});
}

class PostFilter {
  /// Whether to only include posts with media.
  final bool onlyMedia;

  /// Whether to include posts that are replies to other posts.
  final bool includeReplies;

  /// Whether to include repeats of posts.
  final bool includeRepeats;

  /// Whether to include posts marked as sensitive.
  final bool includeSensitive;

  const PostFilter({
    this.onlyMedia = false,
    this.includeReplies = true,
    this.includeRepeats = true,
    this.includeSensitive = true,
  });
}
