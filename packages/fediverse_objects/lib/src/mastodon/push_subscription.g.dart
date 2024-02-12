// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_subscription.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PushSubscription _$PushSubscriptionFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'PushSubscription',
      json,
      ($checkedConvert) {
        final val = PushSubscription(
          alerts: $checkedConvert(
              'alerts',
              (v) =>
                  PushSubscriptionAlerts.fromJson(v as Map<String, dynamic>)),
          endpoint: $checkedConvert('endpoint', (v) => v as String),
          id: $checkedConvert('id', (v) => v as String),
          serverKey: $checkedConvert('server_key', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {'serverKey': 'server_key'},
    );

Map<String, dynamic> _$PushSubscriptionToJson(PushSubscription instance) =>
    <String, dynamic>{
      'alerts': instance.alerts,
      'endpoint': instance.endpoint,
      'id': instance.id,
      'server_key': instance.serverKey,
    };
