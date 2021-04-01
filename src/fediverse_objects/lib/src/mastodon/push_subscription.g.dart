// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_subscription.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MastodonPushSubscription _$MastodonPushSubscriptionFromJson(
    Map<String, dynamic> json) {
  return MastodonPushSubscription(
    alerts: MastodonPushSubscriptionAlerts.fromJson(
        json['alerts'] as Map<String, dynamic>),
    endpoint: json['endpoint'] as String,
    id: json['id'] as String,
    serverKey: json['server_key'] as String,
  );
}

Map<String, dynamic> _$MastodonPushSubscriptionToJson(
        MastodonPushSubscription instance) =>
    <String, dynamic>{
      'alerts': instance.alerts,
      'endpoint': instance.endpoint,
      'id': instance.id,
      'server_key': instance.serverKey,
    };
