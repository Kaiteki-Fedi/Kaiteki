// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scheduled_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MastodonScheduledStatus _$MastodonScheduledStatusFromJson(
    Map<String, dynamic> json) {
  return MastodonScheduledStatus(
    id: json['id'] as String,
    mediaAttachments: (json['media_attachments'] as List)?.map((e) => e == null
        ? null
        : MastodonMediaAttachment.fromJson(e as Map<String, dynamic>)),
    params: json['params'] == null
        ? null
        : MastodonScheduledStatusParams.fromJson(
            json['params'] as Map<String, dynamic>),
    scheduledAt: json['scheduled_at'] == null
        ? null
        : DateTime.parse(json['scheduled_at'] as String),
  );
}
