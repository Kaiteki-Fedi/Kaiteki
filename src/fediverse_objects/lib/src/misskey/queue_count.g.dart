// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queue_count.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyQueueCount _$MisskeyQueueCountFromJson(Map<String, dynamic> json) {
  return MisskeyQueueCount(
    waiting: json['waiting'] as int,
    active: json['active'] as int,
    completed: json['completed'] as int,
    failed: json['failed'] as int,
    delayed: json['delayed'] as int,
    paused: json['paused'] as int,
  );
}

Map<String, dynamic> _$MisskeyQueueCountToJson(MisskeyQueueCount instance) =>
    <String, dynamic>{
      'waiting': instance.waiting,
      'active': instance.active,
      'completed': instance.completed,
      'failed': instance.failed,
      'delayed': instance.delayed,
      'paused': instance.paused,
    };
