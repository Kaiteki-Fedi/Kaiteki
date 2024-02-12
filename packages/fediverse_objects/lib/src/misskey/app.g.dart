// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

App _$AppFromJson(Map<String, dynamic> json) => $checkedCreate(
      'App',
      json,
      ($checkedConvert) {
        final val = App(
          id: $checkedConvert('id', (v) => v as String),
          name: $checkedConvert('name', (v) => v as String),
          callbackUrl: $checkedConvert('callbackUrl', (v) => v as String?),
          permission: $checkedConvert('permission',
              (v) => (v as List<dynamic>).map((e) => e as String).toList()),
          secret: $checkedConvert('secret', (v) => v as String?),
          isAuthorized: $checkedConvert('isAuthorized', (v) => v as bool?),
        );
        return val;
      },
    );

Map<String, dynamic> _$AppToJson(App instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'callbackUrl': instance.callbackUrl,
      'permission': instance.permission,
      'secret': instance.secret,
      'isAuthorized': instance.isAuthorized,
    };
