import 'package:json_annotation/json_annotation.dart';
import 'package:fediverse_objects/mastodon/push_subscription_alerts.dart';
part 'push_subscription.g.dart';

@JsonSerializable(createToJson: false)
class MastodonPushSubscription {
  final MastodonPushSubscriptionAlerts alerts;

  final String endpoint;

  final String id;

  @JsonKey(name: "server_key")
  final String serverKey;

  const MastodonPushSubscription({
    this.alerts,
    this.endpoint,
    this.id,
    this.serverKey,
  });

  factory MastodonPushSubscription.fromJson(Map<String, dynamic> json) =>
      _$MastodonPushSubscriptionFromJson(json);
}
