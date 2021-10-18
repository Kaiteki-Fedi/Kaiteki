import 'package:fediverse_objects/src/mastodon/push_subscription_alerts.dart';
import 'package:json_annotation/json_annotation.dart';

part 'push_subscription.g.dart';

@JsonSerializable()
class PushSubscription {
  final PushSubscriptionAlerts alerts;

  final String endpoint;

  final String id;

  @JsonKey(name: 'server_key')
  final String serverKey;

  const PushSubscription({
    required this.alerts,
    required this.endpoint,
    required this.id,
    required this.serverKey,
  });

  factory PushSubscription.fromJson(Map<String, dynamic> json) =>
      _$PushSubscriptionFromJson(json);

  Map<String, dynamic> toJson() => _$PushSubscriptionToJson(this);
}
