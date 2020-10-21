import 'package:json_annotation/json_annotation.dart';
import 'package:fediverse_objects/mastodon/media_attachment.dart';
import 'package:fediverse_objects/mastodon/scheduled_status_params.dart';
part 'scheduled_status.g.dart';

@JsonSerializable(createToJson: false)
class MastodonScheduledStatus {
  final String id;

  @JsonKey(name: "media_attachments")
  final Iterable<MastodonMediaAttachment> mediaAttachments;

  final MastodonScheduledStatusParams params;

  @JsonKey(name: "scheduled_at")
  final DateTime scheduledAt;

  const MastodonScheduledStatus({
    this.id,
    this.mediaAttachments,
    this.params,
    this.scheduledAt,
  });

  factory MastodonScheduledStatus.fromJson(Map<String, dynamic> json) =>
      _$MastodonScheduledStatusFromJson(json);
}
