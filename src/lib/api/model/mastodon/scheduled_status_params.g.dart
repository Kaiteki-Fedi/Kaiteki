// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scheduled_status_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MastodonScheduledStatusParams _$MastodonScheduledStatusParamsFromJson(
    Map<String, dynamic> json) {
  return MastodonScheduledStatusParams(
    idempotency: json['idempotency'],
    inReplyToId: json['in_reply_to_id'] as String,
    mediaIds: (json['media_ids'] as List)?.map((e) => e as String)?.toList(),
    poll: json['poll'] == null
        ? null
        : MastodonPoll.fromJson(json['poll'] as Map<String, dynamic>),
    scheduledAt: json['scheduled_at'] == null
        ? null
        : DateTime.parse(json['scheduled_at'] as String),
    sensitive: json['sensitive'] as bool,
    spoilerText: json['spoiler_text'] as String,
    text: json['text'] as String,
    visibility: json['visibility'] as String,
  );
}

Map<String, dynamic> _$MastodonScheduledStatusParamsToJson(
        MastodonScheduledStatusParams instance) =>
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
