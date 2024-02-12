// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_subscription_alerts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PushSubscriptionAlerts _$PushSubscriptionAlertsFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'PushSubscriptionAlerts',
      json,
      ($checkedConvert) {
        final val = PushSubscriptionAlerts(
          favourite: $checkedConvert('favourite', (v) => v as bool),
          follow: $checkedConvert('follow', (v) => v as bool),
          mention: $checkedConvert('mention', (v) => v as bool),
          poll: $checkedConvert('poll', (v) => v as bool),
          reblog: $checkedConvert('reblog', (v) => v as bool),
        );
        return val;
      },
    );

Map<String, dynamic> _$PushSubscriptionAlertsToJson(
        PushSubscriptionAlerts instance) =>
    <String, dynamic>{
      'favourite': instance.favourite,
      'follow': instance.follow,
      'mention': instance.mention,
      'poll': instance.poll,
      'reblog': instance.reblog,
    };
