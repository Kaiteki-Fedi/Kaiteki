import 'package:json_annotation/json_annotation.dart';
import 'package:fediverse_objects/src/mastodon/attachment.dart';
import 'package:fediverse_objects/src/mastodon/scheduled_status_params.dart';
part 'scheduled_status.g.dart';

@JsonSerializable()
class MastodonScheduledStatus {
  final String id;

  @JsonKey(name: 'media_attachments')
  final Iterable<MastodonAttachment> mediaAttachments;

  final MastodonScheduledStatusParams params;

  @JsonKey(name: 'scheduled_at')
  final DateTime scheduledAt;

  const MastodonScheduledStatus({
    required this.id,
    required this.mediaAttachments,
    required this.params,
    required this.scheduledAt,
  });

  factory MastodonScheduledStatus.fromJson(Map<String, dynamic> json) =>
      _$MastodonScheduledStatusFromJson(json);

  Map<String, dynamic> toJson() => _$MastodonScheduledStatusToJson(this);
}
