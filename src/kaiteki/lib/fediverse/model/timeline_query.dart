/// A class that represents filter variables for timeline requests.
class TimelineQuery<T> {
  final T? sinceId;
  final T? untilId;
  final bool onlyMedia;
  final bool includeReplies;

  const TimelineQuery({
    this.sinceId,
    this.untilId,
    this.onlyMedia = false,
    this.includeReplies = true,
  });
}
