import 'package:fediverse_objects/src/mastodon/poll.dart';
import 'package:json_annotation/json_annotation.dart';

part 'scheduled_status_params.g.dart';

@JsonSerializable()
class ScheduledStatusParams {
  final dynamic idempotency;

  @JsonKey(name: 'in_reply_to_id')
  final String? inReplyToId;

  @JsonKey(name: 'media_ids')
  final List<String>? mediaIds;

  final Poll? poll;

  @JsonKey(name: 'scheduled_at')
  final DateTime? scheduledAt;

  final bool? sensitive;

  @JsonKey(name: 'spoiler_text')
  final String? spoilerText;

  final String text;

  final String visibility;

  const ScheduledStatusParams({
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

  factory ScheduledStatusParams.fromJson(Map<String, dynamic> json) =>
      _$ScheduledStatusParamsFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduledStatusParamsToJson(this);
}
