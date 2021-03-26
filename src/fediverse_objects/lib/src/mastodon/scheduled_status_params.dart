import 'package:json_annotation/json_annotation.dart';
import 'package:fediverse_objects/src/mastodon/poll.dart';
part 'scheduled_status_params.g.dart';

@JsonSerializable()
class MastodonScheduledStatusParams {
  final dynamic idempotency;

  @JsonKey(name: 'in_reply_to_id')
  final String? inReplyToId;

  @JsonKey(name: 'media_ids')
  final List<String>? mediaIds;

  final MastodonPoll? poll;

  @JsonKey(name: 'scheduled_at')
  final DateTime? scheduledAt;

  final bool? sensitive;

  @JsonKey(name: 'spoiler_text')
  final String? spoilerText;

  final String text;

  final String visibility;

  const MastodonScheduledStatusParams({
    required this.text,
    required this.visibility,
    this.poll,
    this.idempotency,
    this.inReplyToId,
    this.mediaIds,
    this.scheduledAt,
    this.sensitive,
    this.spoilerText,
  });

  factory MastodonScheduledStatusParams.fromJson(Map<String, dynamic> json) =>
      _$MastodonScheduledStatusParamsFromJson(json);

  Map<String, dynamic> toJson() => _$MastodonScheduledStatusParamsToJson(this);
}
