// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mention.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MastodonMention _$MastodonMentionFromJson(Map<String, dynamic> json) {
  return MastodonMention(
    account: json['acct'] as String,
    id: json['id'] as String,
    url: json['url'] as String,
    username: json['username'] as String,
  );
}

Map<String, dynamic> _$MastodonMentionToJson(MastodonMention instance) =>
    <String, dynamic>{
      'acct': instance.account,
      'id': instance.id,
      'url': instance.url,
      'username': instance.username,
    };
