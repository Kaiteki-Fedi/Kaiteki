// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scheduled_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MastodonScheduledStatus _$MastodonScheduledStatusFromJson(
    Map<String, dynamic> json) {
  return MastodonScheduledStatus(
    id: json['id'] as String,
    mediaAttachments: (json['media_attachments'] as List<dynamic>)
        .map((e) => MastodonAttachment.fromJson(e as Map<String, dynamic>)),
    params: MastodonScheduledStatusParams.fromJson(
        json['params'] as Map<String, dynamic>),
    scheduledAt: DateTime.parse(json['scheduled_at'] as String),
  );
}

Map<String, dynamic> _$MastodonScheduledStatusToJson(
        MastodonScheduledStatus instance) =>
    <String, dynamic>{
      'id': instance.id,
      'media_attachments': instance.mediaAttachments.toList(),
      'params': instance.params,
      'scheduled_at': instance.scheduledAt.toIso8601String(),
    };
