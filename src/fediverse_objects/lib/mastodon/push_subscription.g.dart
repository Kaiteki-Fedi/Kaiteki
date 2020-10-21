// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_subscription.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MastodonPushSubscription _$MastodonPushSubscriptionFromJson(
    Map<String, dynamic> json) {
  return MastodonPushSubscription(
    alerts: json['alerts'] == null
        ? null
        : MastodonPushSubscriptionAlerts.fromJson(
            json['alerts'] as Map<String, dynamic>),
    endpoint: json['endpoint'] as String,
    id: json['id'] as String,
    serverKey: json['server_key'] as String,
  );
}
