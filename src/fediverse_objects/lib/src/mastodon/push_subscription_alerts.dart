import 'package:json_annotation/json_annotation.dart';

part 'push_subscription_alerts.g.dart';

@JsonSerializable()
class PushSubscriptionAlerts {
  /// Receive a push notification when a status you created has been favourited by someone else?
  final bool favourite;

  /// Receive a push notification when someone has followed you?
  final bool follow;

  /// Receive a push notification when someone else has mentioned you in a status?
  final bool mention;

  /// Receive a push notification when a poll you voted in or created has ended?
  final bool poll;

  /// Receive a push notification when a status you created has been boosted by someone else?
  final bool reblog;

  const PushSubscriptionAlerts({
    required this.favourite,
    required this.follow,
    required this.mention,
    required this.poll,
    required this.reblog,
  });

  factory PushSubscriptionAlerts.fromJson(Map<String, dynamic> json) =>
      _$PushSubscriptionAlertsFromJson(json);

  Map<String, dynamic> toJson() => _$PushSubscriptionAlertsToJson(this);
}
