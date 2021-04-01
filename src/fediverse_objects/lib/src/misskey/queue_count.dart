import 'package:json_annotation/json_annotation.dart';
part 'queue_count.g.dart';

@JsonSerializable()
class MisskeyQueueCount {
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
  
  const MisskeyQueueCount({
    required this.waiting,
    required this.active,
    required this.completed,
    required this.failed,
    required this.delayed,
    required this.paused,
  });

  factory MisskeyQueueCount.fromJson(Map<String, dynamic> json) => _$MisskeyQueueCountFromJson(json);
  Map<String, dynamic> toJson() => _$MisskeyQueueCountToJson(this);
}
