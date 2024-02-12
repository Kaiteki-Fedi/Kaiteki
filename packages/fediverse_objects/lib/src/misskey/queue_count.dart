import 'package:json_annotation/json_annotation.dart';
part 'queue_count.g.dart';

@JsonSerializable()
class QueueCount {
  final int waiting;

  final int active;

  final int completed;

  final int failed;

  final int delayed;

  const QueueCount({
    required this.waiting,
    required this.active,
    required this.completed,
    required this.failed,
    required this.delayed,
  });

  factory QueueCount.fromJson(Map<String, dynamic> json) =>
      _$QueueCountFromJson(json);
  Map<String, dynamic> toJson() => _$QueueCountToJson(this);
}
