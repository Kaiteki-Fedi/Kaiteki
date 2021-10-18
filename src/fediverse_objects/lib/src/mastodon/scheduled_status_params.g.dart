// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scheduled_status_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduledStatusParams _$ScheduledStatusParamsFromJson(
    Map<String, dynamic> json) {
  return ScheduledStatusParams(
    text: json['text'] as String,
    visibility: json['visibility'] as String,
    poll: json['poll'] == null
        ? null
        : Poll.fromJson(json['poll'] as Map<String, dynamic>),
    idempotency: json['idempotency'],
    inReplyToId: json['in_reply_to_id'] as String?,
    mediaIds:
        (json['media_ids'] as List<dynamic>?)?.map((e) => e as String).toList(),
    scheduledAt: json['scheduled_at'] == null
        ? null
        : DateTime.parse(json['scheduled_at'] as String),
    sensitive: json['sensitive'] as bool?,
    spoilerText: json['spoiler_text'] as String?,
  );
}

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
