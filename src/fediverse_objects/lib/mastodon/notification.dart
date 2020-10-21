import 'package:json_annotation/json_annotation.dart';
import 'package:fediverse_objects/pleroma/notification.dart';
import 'package:fediverse_objects/mastodon/account.dart';
import 'package:fediverse_objects/mastodon/status.dart';
part 'notification.g.dart';

@JsonSerializable(createToJson: false)
class MastodonNotification {
  final MastodonAccount account;

  @JsonKey(name: "created_at")
  final DateTime createdAt;

  final String id;

  final PleromaNotification pleroma;

  final MastodonStatus status;

  final String type;

  const MastodonNotification({
    this.account,
    this.createdAt,
    this.id,
    this.pleroma,
    this.status,
    this.type,
  });

  factory MastodonNotification.fromJson(Map<String, dynamic> json) =>
      _$MastodonNotificationFromJson(json);
}
