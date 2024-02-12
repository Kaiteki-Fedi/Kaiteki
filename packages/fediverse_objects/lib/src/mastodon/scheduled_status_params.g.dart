// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scheduled_status_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduledStatusParams _$ScheduledStatusParamsFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'ScheduledStatusParams',
      json,
      ($checkedConvert) {
        final val = ScheduledStatusParams(
          text: $checkedConvert('text', (v) => v as String),
          visibility: $checkedConvert('visibility', (v) => v as String),
          poll: $checkedConvert(
              'poll',
              (v) =>
                  v == null ? null : Poll.fromJson(v as Map<String, dynamic>)),
          idempotency: $checkedConvert('idempotency', (v) => v),
          inReplyToId: $checkedConvert('in_reply_to_id', (v) => v as String?),
          mediaIds: $checkedConvert('media_ids',
              (v) => (v as List<dynamic>?)?.map((e) => e as String).toList()),
          scheduledAt: $checkedConvert('scheduled_at',
              (v) => v == null ? null : DateTime.parse(v as String)),
          sensitive: $checkedConvert('sensitive', (v) => v as bool?),
          spoilerText: $checkedConvert('spoiler_text', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'inReplyToId': 'in_reply_to_id',
        'mediaIds': 'media_ids',
        'scheduledAt': 'scheduled_at',
        'spoilerText': 'spoiler_text'
      },
    );

Map<String, dynamic> _$ScheduledStatusParamsToJson(
        ScheduledStatusParams instance) =>
    <String, dynamic>{
      'idempotency': instance.idempotency,
      'in_reply_to_id': instance.inReplyToId,
      'media_ids': instance.mediaIds,
      'poll': instance.poll,
      'scheduled_at': instance.scheduledAt?.toIso8601String(),
      'sensitive': instance.sensitive,
      'spoiler_text': instance.spoilerText,
      'text': instance.text,
      'visibility': instance.visibility,
    };
