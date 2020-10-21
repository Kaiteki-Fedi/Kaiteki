import 'package:json_annotation/json_annotation.dart';
import 'package:fediverse_objects/mastodon/poll.dart';
part 'scheduled_status_params.g.dart';

@JsonSerializable(createToJson: false)
class MastodonScheduledStatusParams {
  final dynamic idempotency;

  @JsonKey(name: "in_reply_to_id")
  final String inReplyToId;

  @JsonKey(name: "media_ids")
  final List<String> mediaIds;

  final MastodonPoll poll;

  @JsonKey(name: "scheduled_at")
  final DateTime scheduledAt;

  final bool sensitive;

  @JsonKey(name: "spoiler_text")
  final String spoilerText;

  final String text;

  final String visibility;

  const MastodonScheduledStatusParams({
    this.idempotency,
    this.inReplyToId,
    this.mediaIds,
    this.poll,
    this.scheduledAt,
    this.sensitive,
    this.spoilerText,
    this.text,
    this.visibility,
  });

  factory MastodonScheduledStatusParams.fromJson(Map<String, dynamic> json) =>
      _$MastodonScheduledStatusParamsFromJson(json);
}
