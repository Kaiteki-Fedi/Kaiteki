import 'package:fediverse_objects/src/mastodon/attachment.dart';
import 'package:fediverse_objects/src/mastodon/scheduled_status_params.dart';
import 'package:json_annotation/json_annotation.dart';

part 'scheduled_status.g.dart';

@JsonSerializable()
class ScheduledStatus {
  final String id;

  @JsonKey(name: 'media_attachments')
  final Iterable<Attachment> mediaAttachments;

  final ScheduledStatusParams params;

  @JsonKey(name: 'scheduled_at')
  final DateTime scheduledAt;

  const ScheduledStatus({
    required this.id,
    required this.mediaAttachments,
    required this.params,
    required this.scheduledAt,
  });

  factory ScheduledStatus.fromJson(Map<String, dynamic> json) =>
      _$ScheduledStatusFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduledStatusToJson(this);
}
