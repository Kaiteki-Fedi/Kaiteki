// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MastodonAccount _$MastodonAccountFromJson(Map<String, dynamic> json) {
  return MastodonAccount(
    id: json['id'] as String,
    username: json['username'] as String,
    url: json['url'] as String,
    acct: json['acct'] as String,
    displayName: json['display_name'] as String,
    note: json['note'] as String,
    avatar: json['avatar'] as String,
    avatarStatic: json['avatar_static'] as String,
    header: json['header'] as String,
    headerStatic: json['header_static'] as String,
    locked: json['locked'] as bool,
    emojis: (json['emojis'] as List)?.map((e) =>
        e == null ? null : MastodonEmoji.fromJson(e as Map<String, dynamic>)),
    discoverable: json['discoverable'] as bool,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    lastStatusAt: json['last_status_at'] == null
        ? null
        : DateTime.parse(json['last_status_at'] as String),
    statusesCount: json['statuses_count'] as int,
    followersCount: json['followers_count'] as int,
    followingCount: json['following_count'] as int,
    moved: json['moved'] as bool,
    fields: (json['fields'] as List)?.map((e) =>
        e == null ? null : MastodonField.fromJson(e as Map<String, dynamic>)),
    bot: json['bot'] as bool,
    source: json['source'] == null
        ? null
        : MastodonSource.fromJson(json['source'] as Map<String, dynamic>),
    pleroma: json['pleroma'] == null
        ? null
        : PleromaAccount.fromJson(json['pleroma'] as Map<String, dynamic>),
    suspended: json['suspended'] as bool,
    muteExpiredAt: json['muteExpiredAt'] == null
        ? null
        : DateTime.parse(json['muteExpiredAt'] as String),
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
      'source': instance.source,
      'statuses_count': instance.statusesCount,
      'url': instance.url,
      'username': instance.username,
      'discoverable': instance.discoverable,
      'last_status_at': instance.lastStatusAt?.toIso8601String(),
      'moved': instance.moved,
      'suspended': instance.suspended,
      'muteExpiredAt': instance.muteExpiredAt?.toIso8601String(),
    };
