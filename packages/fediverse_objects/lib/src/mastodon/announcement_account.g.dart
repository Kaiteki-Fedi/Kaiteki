// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnnouncementAccount _$AnnouncementAccountFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'AnnouncementAccount',
      json,
      ($checkedConvert) {
        final val = AnnouncementAccount(
          id: $checkedConvert('id', (v) => v as String),
          username: $checkedConvert('username', (v) => v as String),
          acct: $checkedConvert('acct', (v) => v as String),
          url: $checkedConvert('url', (v) => Uri.parse(v as String)),
        );
        return val;
      },
    );

Map<String, dynamic> _$AnnouncementAccountToJson(
        AnnouncementAccount instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'acct': instance.acct,
      'url': instance.url.toString(),
    };
