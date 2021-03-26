import 'package:json_annotation/json_annotation.dart';
import 'package:fediverse_objects/src/mastodon/push_subscription_alerts.dart';
part 'push_subscription.g.dart';

@JsonSerializable()
class MastodonPushSubscription {
  final MastodonPushSubscriptionAlerts alerts;

  final String endpoint;

  final String id;

  @JsonKey(name: 'server_key')
  final String serverKey;

  const MastodonPushSubscription({
    required this.alerts,
    required this.endpoint,
    required this.id,
    required this.serverKey,
  });

  factory MastodonPushSubscription.fromJson(Map<String, dynamic> json) =>
      _$MastodonPushSubscriptionFromJson(json);

  Map<String, dynamic> toJson() => _$MastodonPushSubscriptionToJson(this);
}
