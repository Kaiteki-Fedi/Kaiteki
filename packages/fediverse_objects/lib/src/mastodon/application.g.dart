// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Application _$ApplicationFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Application',
      json,
      ($checkedConvert) {
        final val = Application(
          name: $checkedConvert('name', (v) => v as String),
          website: $checkedConvert('website', (v) => v as String?),
          vapidKey: $checkedConvert('vapid_key', (v) => v as String?),
          clientId: $checkedConvert('client_id', (v) => v as String?),
          clientSecret: $checkedConvert('client_secret', (v) => v as String?),
          id: $checkedConvert('id', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'vapidKey': 'vapid_key',
        'clientId': 'client_id',
        'clientSecret': 'client_secret'
      },
    );

Map<String, dynamic> _$ApplicationToJson(Application instance) =>
    <String, dynamic>{
      'client_id': instance.clientId,
      'client_secret': instance.clientSecret,
      'id': instance.id,
      'name': instance.name,
      'vapid_key': instance.vapidKey,
      'website': instance.website,
    };
