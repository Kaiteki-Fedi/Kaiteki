// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credential_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CredentialAccount _$CredentialAccountFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'CredentialAccount',
      json,
      ($checkedConvert) {
        final val = CredentialAccount(
          acct: $checkedConvert('acct', (v) => v as String),
          avatar: $checkedConvert('avatar', (v) => v as String),
          avatarStatic: $checkedConvert('avatarStatic', (v) => v as String),
          createdAt:
              $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
          displayName: $checkedConvert('displayName', (v) => v as String),
          emojis: $checkedConvert(
              'emojis',
              (v) => (v as List<dynamic>)
                  .map((e) => CustomEmoji.fromJson(e as Map<String, dynamic>))
                  .toList()),
          followersCount: $checkedConvert('followersCount', (v) => v as int),
          followingCount: $checkedConvert('followingCount', (v) => v as int),
          group: $checkedConvert('group', (v) => v as bool?),
          header: $checkedConvert('header', (v) => v as String),
          headerStatic: $checkedConvert('headerStatic', (v) => v as String),
          id: $checkedConvert('id', (v) => v as String),
          locked: $checkedConvert('locked', (v) => v as bool),
          note: $checkedConvert('note', (v) => v as String),
          statusesCount: $checkedConvert('statusesCount', (v) => v as int),
          url: $checkedConvert('url', (v) => v as String),
          username: $checkedConvert('username', (v) => v as String),
          source: $checkedConvert(
              'source',
              (v) => v == null
                  ? null
                  : Source.fromJson(v as Map<String, dynamic>)),
          bot: $checkedConvert('bot', (v) => v as bool?),
          discoverable: $checkedConvert('discoverable', (v) => v as bool?),
          fields: $checkedConvert(
              'fields',
              (v) => (v as List<dynamic>?)
                  ?.map((e) => Field.fromJson(e as Map<String, dynamic>))
                  .toList()),
          lastStatusAt: $checkedConvert('lastStatusAt',
              (v) => v == null ? null : DateTime.parse(v as String)),
          limited: $checkedConvert('limited', (v) => v as bool?),
          moved: $checkedConvert(
              'moved',
              (v) => v == null
                  ? null
                  : Account.fromJson(v as Map<String, dynamic>)),
          muteExpiredAt: $checkedConvert('muteExpiredAt',
              (v) => v == null ? null : DateTime.parse(v as String)),
          noindex: $checkedConvert('noindex', (v) => v as bool?),
          pleroma: $checkedConvert(
              'pleroma',
              (v) => v == null
                  ? null
                  : PleromaAccount.fromJson(v as Map<String, dynamic>)),
          suspended: $checkedConvert('suspended', (v) => v as bool?),
          role: $checkedConvert(
              'role',
              (v) =>
                  v == null ? null : Role.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
    );

Map<String, dynamic> _$CredentialAccountToJson(CredentialAccount instance) =>
    <String, dynamic>{
      'acct': instance.acct,
      'avatar': instance.avatar,
      'avatarStatic': instance.avatarStatic,
      'bot': instance.bot,
      'createdAt': instance.createdAt.toIso8601String(),
      'displayName': instance.displayName,
      'emojis': instance.emojis,
      'fields': instance.fields,
      'followersCount': instance.followersCount,
      'followingCount': instance.followingCount,
      'header': instance.header,
      'headerStatic': instance.headerStatic,
      'id': instance.id,
      'locked': instance.locked,
      'note': instance.note,
      'pleroma': instance.pleroma,
      'source': instance.source,
      'statusesCount': instance.statusesCount,
      'url': instance.url,
      'username': instance.username,
      'discoverable': instance.discoverable,
      'lastStatusAt': instance.lastStatusAt?.toIso8601String(),
      'moved': instance.moved,
      'suspended': instance.suspended,
      'muteExpiredAt': instance.muteExpiredAt?.toIso8601String(),
      'group': instance.group,
      'limited': instance.limited,
      'noindex': instance.noindex,
      'role': instance.role,
    };
