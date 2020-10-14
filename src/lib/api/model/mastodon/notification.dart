import 'package:json_annotation/json_annotation.dart';
import 'package:kaiteki/api/model/mastodon/account.dart';
import 'package:kaiteki/api/model/mastodon/status.dart';
import 'package:kaiteki/api/model/pleroma/notification.dart';
part 'notification.g.dart';

@JsonSerializable()
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

  factory MastodonNotification.fromJson(Map<String, dynamic> json) => _$MastodonNotificationFromJson(json);
}