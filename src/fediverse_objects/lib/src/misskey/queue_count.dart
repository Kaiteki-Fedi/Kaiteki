import 'package:json_annotation/json_annotation.dart';

part 'queue_count.g.dart';

@JsonSerializable()
class QueueCount {
  @JsonKey(name: 'waiting')
  final int waiting;

  @JsonKey(name: 'active')
  final int active;

  @JsonKey(name: 'completed')
  final int completed;

  @JsonKey(name: 'failed')
  final int failed;

  @JsonKey(name: 'delayed')
  final int delayed;

  @JsonKey(name: 'paused')
  final int paused;

  const QueueCount({
    required this.waiting,
    required this.active,
    required this.completed,
    required this.failed,
    required this.delayed,
    required this.paused,
  });

  factory QueueCount.fromJson(Map<String, dynamic> json) =>
      _$QueueCountFromJson(json);
  Map<String, dynamic> toJson() => _$QueueCountToJson(this);
}
