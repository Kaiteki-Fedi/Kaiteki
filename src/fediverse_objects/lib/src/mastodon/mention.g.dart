// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mention.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Mention _$MentionFromJson(Map<String, dynamic> json) {
  return Mention(
    account: json['acct'] as String,
    id: json['id'] as String,
    url: json['url'] as String,
    username: json['username'] as String,
  );
}

Map<String, dynamic> _$MentionToJson(Mention instance) => <String, dynamic>{
      'acct': instance.account,
      'id': instance.id,
      'url': instance.url,
      'username': instance.username,
    };
