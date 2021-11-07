// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_subscription.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PushSubscription _$PushSubscriptionFromJson(Map<String, dynamic> json) =>
    PushSubscription(
      alerts: PushSubscriptionAlerts.fromJson(
          json['alerts'] as Map<String, dynamic>),
      endpoint: json['endpoint'] as String,
      id: json['id'] as String,
      serverKey: json['server_key'] as String,
    );

Map<String, dynamic> _$PushSubscriptionToJson(PushSubscription instance) =>
    <String, dynamic>{
      'alerts': instance.alerts,
      'endpoint': instance.endpoint,
      'id': instance.id,
      'server_key': instance.serverKey,
    };
