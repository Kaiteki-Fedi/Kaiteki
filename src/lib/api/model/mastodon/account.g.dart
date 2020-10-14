// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MastodonAccount _$MastodonAccountFromJson(Map<String, dynamic> json) {
  return MastodonAccount(
    acct: json['acct'] as String,
    avatar: json['avatar'] as String,
    avatarStatic: json['avatar_static'] as String,
    bot: json['bot'] as bool,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    displayName: json['display_name'] as String,
    emojis: (json['emojis'] as List)?.map((e) =>
        e == null ? null : MastodonEmoji.fromJson(e as Map<String, dynamic>)),
    fields: (json['fields'] as List)?.map((e) => e == null
        ? null
        : MastodonAccountField.fromJson(e as Map<String, dynamic>)),
    followersCount: json['followers_count'] as int,
    followingCount: json['following_count'] as int,
    header: json['header'] as String,
    headerStatic: json['header_static'] as String,
    id: json['id'] as String,
    locked: json['locked'] as bool,
    note: json['note'] as String,
    pleroma: json['pleroma'] == null
        ? null
        : PleromaAccount.fromJson(json['pleroma'] as Map<String, dynamic>),
    statusesCount: json['statuses_count'] as int,
    url: json['url'] as String,
    username: json['username'] as String,
  );
}

Map<String, dynamic> _$MastodonAccountToJson(MastodonAccount instance) =>
    <String, dynamic>{
      'acct': instance.acct,
      'avatar': instance.avatar,
      'avatar_static': instance.avatarStatic,
      'bot': instance.bot,
      'created_at': instance.createdAt?.toIso8601String(),
      'display_name': instance.displayName,
      'emojis': instance.emojis?.toList(),
      'fields': instance.fields?.toList(),
      'followers_count': instance.followersCount,
      'following_count': instance.followingCount,
      'header': instance.header,
      'header_static': instance.headerStatic,
      'id': instance.id,
      'locked': instance.locked,
      'note': instance.note,
      'pleroma': instance.pleroma,
      'statuses_count': instance.statusesCount,
      'url': instance.url,
      'username': instance.username,
    };
