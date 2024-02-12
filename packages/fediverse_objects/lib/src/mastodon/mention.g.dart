// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mention.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Mention _$MentionFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Mention',
      json,
      ($checkedConvert) {
        final val = Mention(
          account: $checkedConvert('acct', (v) => v as String),
          id: $checkedConvert('id', (v) => v as String),
          url: $checkedConvert('url', (v) => v as String),
          username: $checkedConvert('username', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {'account': 'acct'},
    );

Map<String, dynamic> _$MentionToJson(Mention instance) => <String, dynamic>{
      'acct': instance.account,
      'id': instance.id,
      'url': instance.url,
      'username': instance.username,
    };
