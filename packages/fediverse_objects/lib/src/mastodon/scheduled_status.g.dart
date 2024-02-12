// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scheduled_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduledStatus _$ScheduledStatusFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'ScheduledStatus',
      json,
      ($checkedConvert) {
        final val = ScheduledStatus(
          id: $checkedConvert('id', (v) => v as String),
          mediaAttachments: $checkedConvert(
              'media_attachments',
              (v) => (v as List<dynamic>)
                  .map((e) =>
                      MediaAttachment.fromJson(e as Map<String, dynamic>))
                  .toList()),
          params: $checkedConvert('params',
              (v) => ScheduledStatusParams.fromJson(v as Map<String, dynamic>)),
          scheduledAt: $checkedConvert(
              'scheduled_at', (v) => DateTime.parse(v as String)),
        );
        return val;
      },
      fieldKeyMap: const {
        'mediaAttachments': 'media_attachments',
        'scheduledAt': 'scheduled_at'
      },
    );

Map<String, dynamic> _$ScheduledStatusToJson(ScheduledStatus instance) =>
    <String, dynamic>{
      'id': instance.id,
      'media_attachments': instance.mediaAttachments,
      'params': instance.params,
      'scheduled_at': instance.scheduledAt.toIso8601String(),
    };
