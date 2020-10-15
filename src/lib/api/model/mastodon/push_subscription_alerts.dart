import 'package:json_annotation/json_annotation.dart';
part 'push_subscription_alerts.g.dart';

@JsonSerializable(createToJson: false)
class MastodonPushSubscriptionAlerts {
  final bool favourite;

  final bool follow;

  final bool mention;

  final bool poll;

  final bool reblog;

  const MastodonPushSubscriptionAlerts({
    this.favourite,
    this.follow,
    this.mention,
    this.poll,
    this.reblog,
  });

  factory MastodonPushSubscriptionAlerts.fromJson(Map<String, dynamic> json) => _$MastodonPushSubscriptionAlertsFromJson(json);
}