// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queue_count.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueueCount _$QueueCountFromJson(Map<String, dynamic> json) => $checkedCreate(
      'QueueCount',
      json,
      ($checkedConvert) {
        final val = QueueCount(
          waiting: $checkedConvert('waiting', (v) => v as int),
          active: $checkedConvert('active', (v) => v as int),
          completed: $checkedConvert('completed', (v) => v as int),
          failed: $checkedConvert('failed', (v) => v as int),
          delayed: $checkedConvert('delayed', (v) => v as int),
        );
        return val;
      },
    );

Map<String, dynamic> _$QueueCountToJson(QueueCount instance) =>
    <String, dynamic>{
      'waiting': instance.waiting,
      'active': instance.active,
      'completed': instance.completed,
      'failed': instance.failed,
      'delayed': instance.delayed,
    };
