// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Account _$AccountFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Account',
      json,
      ($checkedConvert) {
        final val = Account(
          acct: $checkedConvert('acct', (v) => v as String),
          avatar: $checkedConvert('avatar', (v) => v as String),
          avatarStatic: $checkedConvert('avatar_static', (v) => v as String),
          createdAt:
              $checkedConvert('created_at', (v) => DateTime.parse(v as String)),
          displayName: $checkedConvert('display_name', (v) => v as String),
          emojis: $checkedConvert(
              'emojis',
              (v) => (v as List<dynamic>)
                  .map((e) => CustomEmoji.fromJson(e as Map<String, dynamic>))
                  .toList()),
          followersCount: $checkedConvert('followers_count', (v) => v as int),
          followingCount: $checkedConvert('following_count', (v) => v as int),
          group: $checkedConvert('group', (v) => v as bool?),
          header: $checkedConvert('header', (v) => v as String),
          headerStatic: $checkedConvert('header_static', (v) => v as String),
          id: $checkedConvert('id', (v) => v as String),
          locked: $checkedConvert('locked', (v) => v as bool),
          note: $checkedConvert('note', (v) => v as String),
          statusesCount: $checkedConvert('statuses_count', (v) => v as int),
          url: $checkedConvert('url', (v) => v as String),
          username: $checkedConvert('username', (v) => v as String),
          bot: $checkedConvert('bot', (v) => v as bool?),
          discoverable: $checkedConvert('discoverable', (v) => v as bool?),
          fields: $checkedConvert(
              'fields',
              (v) => (v as List<dynamic>?)
                  ?.map((e) => Field.fromJson(e as Map<String, dynamic>))
                  .toList()),
          lastStatusAt: $checkedConvert('last_status_at',
              (v) => v == null ? null : DateTime.parse(v as String)),
          limited: $checkedConvert('limited', (v) => v as bool?),
          moved: $checkedConvert(
              'moved',
              (v) => v == null
                  ? null
                  : Account.fromJson(v as Map<String, dynamic>)),
          muteExpiredAt: $checkedConvert('mute_expired_at',
              (v) => v == null ? null : DateTime.parse(v as String)),
          noindex: $checkedConvert('noindex', (v) => v as bool?),
          pleroma: $checkedConvert(
              'pleroma',
              (v) => v == null
                  ? null
                  : PleromaAccount.fromJson(v as Map<String, dynamic>)),
          source: $checkedConvert(
              'source',
              (v) => v == null
                  ? null
                  : Source.fromJson(v as Map<String, dynamic>)),
          suspended: $checkedConvert('suspended', (v) => v as bool?),
        );
        return val;
      },
      fieldKeyMap: const {
        'avatarStatic': 'avatar_static',
        'createdAt': 'created_at',
        'displayName': 'display_name',
        'followersCount': 'followers_count',
        'followingCount': 'following_count',
        'headerStatic': 'header_static',
        'statusesCount': 'statuses_count',
        'lastStatusAt': 'last_status_at',
        'muteExpiredAt': 'mute_expired_at'
      },
    );

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
      'acct': instance.acct,
      'avatar': instance.avatar,
      'avatar_static': instance.avatarStatic,
      'bot': instance.bot,
      'created_at': instance.createdAt.toIso8601String(),
      'display_name': instance.displayName,
      'emojis': instance.emojis,
      'fields': instance.fields,
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
      'mute_expired_at': instance.muteExpiredAt?.toIso8601String(),
      'group': instance.group,
      'limited': instance.limited,
      'noindex': instance.noindex,
    };
