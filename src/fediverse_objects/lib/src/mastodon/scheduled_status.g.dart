// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scheduled_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduledStatus _$ScheduledStatusFromJson(Map<String, dynamic> json) =>
    ScheduledStatus(
      id: json['id'] as String,
      mediaAttachments: (json['media_attachments'] as List<dynamic>)
          .map((e) => Attachment.fromJson(e as Map<String, dynamic>)),
      params: ScheduledStatusParams.fromJson(
          json['params'] as Map<String, dynamic>),
      scheduledAt: DateTime.parse(json['scheduled_at'] as String),
    );

Map<String, dynamic> _$ScheduledStatusToJson(ScheduledStatus instance) =>
    <String, dynamic>{
      'id': instance.id,
      'media_attachments': instance.mediaAttachments.toList(),
      'params': instance.params,
      'scheduled_at': instance.scheduledAt.toIso8601String(),
    };
