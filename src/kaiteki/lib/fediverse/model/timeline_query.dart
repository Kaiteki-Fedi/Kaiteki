/// A class that represents filter variables for timeline requests.
class TimelineQuery<T> {
  final T? sinceId;
  final T? untilId;

  const TimelineQuery({this.sinceId, this.untilId});
}
