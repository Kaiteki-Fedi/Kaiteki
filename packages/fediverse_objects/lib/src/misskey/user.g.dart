// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => $checkedCreate(
      'User',
      json,
      ($checkedConvert) {
        final val = User(
          id: $checkedConvert('id', (v) => v as String),
          username: $checkedConvert('username', (v) => v as String),
          alwaysMarkNsfw: $checkedConvert('alwaysMarkNsfw', (v) => v as bool?),
          autoAcceptFollowed:
              $checkedConvert('autoAcceptFollowed', (v) => v as bool?),
          autoWatch: $checkedConvert('autoWatch', (v) => v as bool?),
          avatarBlurhash:
              $checkedConvert('avatarBlurhash', (v) => v as String?),
          avatarDecorations: $checkedConvert(
              'avatarDecorations',
              (v) => (v as List<dynamic>?)
                  ?.map((e) =>
                      AvatarDecoration.fromJson(e as Map<String, dynamic>))
                  .toList()),
          avatarId: $checkedConvert('avatarId', (v) => v as String?),
          avatarUrl: $checkedConvert(
              'avatarUrl', (v) => v == null ? null : Uri.parse(v as String)),
          backgroundId: $checkedConvert('backgroundId', (v) => v as String?),
          backgroundUrl: $checkedConvert('backgroundUrl',
              (v) => v == null ? null : Uri.parse(v as String)),
          bannerBlurhash:
              $checkedConvert('bannerBlurhash', (v) => v as String?),
          bannerId: $checkedConvert('bannerId', (v) => v as String?),
          bannerUrl: $checkedConvert(
              'bannerUrl', (v) => v == null ? null : Uri.parse(v as String)),
          birthday: $checkedConvert('birthday', (v) => v as String?),
          carefulBot: $checkedConvert('carefulBot', (v) => v as bool?),
          createdAt: $checkedConvert('createdAt',
              (v) => v == null ? null : DateTime.parse(v as String)),
          description: $checkedConvert('description', (v) => v as String?),
          emojis: $checkedConvert(
            'emojis',
            (v) => (v as List<dynamic>?)
                ?.map((e) => Emoji.fromJson(e as Map<String, dynamic>))
                .toList(),
            readValue: misskeyEmojisReadValue,
          ),
          fields: $checkedConvert(
              'fields',
              (v) => (v as List<dynamic>?)
                  ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
                  .toList()),
          followersCount: $checkedConvert('followersCount', (v) => v as int?),
          followingCount: $checkedConvert('followingCount', (v) => v as int?),
          hasPendingFollowRequestFromYou: $checkedConvert(
              'hasPendingFollowRequestFromYou', (v) => v as bool?),
          hasPendingFollowRequestToYou: $checkedConvert(
              'hasPendingFollowRequestToYou', (v) => v as bool?),
          hasPendingReceivedFollowRequest: $checkedConvert(
              'hasPendingReceivedFollowRequest', (v) => v as bool?),
          hasUnreadAnnouncement:
              $checkedConvert('hasUnreadAnnouncement', (v) => v as bool?),
          hasUnreadAntenna:
              $checkedConvert('hasUnreadAntenna', (v) => v as bool?),
          hasUnreadChannel:
              $checkedConvert('hasUnreadChannel', (v) => v as bool?),
          hasUnreadMentions:
              $checkedConvert('hasUnreadMentions', (v) => v as bool?),
          hasUnreadMessagingMessage:
              $checkedConvert('hasUnreadMessagingMessage', (v) => v as bool?),
          hasUnreadNotification:
              $checkedConvert('hasUnreadNotification', (v) => v as bool?),
          hasUnreadSpecifiedNotes:
              $checkedConvert('hasUnreadSpecifiedNotes', (v) => v as bool?),
          host: $checkedConvert('host', (v) => v as String?),
          injectFeaturedNote:
              $checkedConvert('injectFeaturedNote', (v) => v as bool?),
          isAdmin: $checkedConvert('isAdmin', (v) => v as bool?),
          isBlocked: $checkedConvert('isBlocked', (v) => v as bool?),
          isBlocking: $checkedConvert('isBlocking', (v) => v as bool?),
          isBot: $checkedConvert('isBot', (v) => v as bool?),
          isCat: $checkedConvert('isCat', (v) => v as bool?),
          isFollowed: $checkedConvert('isFollowed', (v) => v as bool?),
          isFollowing: $checkedConvert('isFollowing', (v) => v as bool?),
          isLocked: $checkedConvert('isLocked', (v) => v as bool?),
          isModerator: $checkedConvert('isModerator', (v) => v as bool?),
          isMuted: $checkedConvert('isMuted', (v) => v as bool?),
          isSuspended: $checkedConvert('isSuspended', (v) => v as bool?),
          location: $checkedConvert('location', (v) => v as String?),
          mutedInstances: $checkedConvert('mutedInstances',
              (v) => (v as List<dynamic>?)?.map((e) => e as String).toList()),
          mutedWords: $checkedConvert(
              'mutedWords',
              (v) => (v as List<dynamic>?)
                  ?.map((e) =>
                      (e as List<dynamic>).map((e) => e as String).toList())
                  .toList()),
          name: $checkedConvert('name', (v) => v as String?),
          notesCount: $checkedConvert('notesCount', (v) => v as int?),
          onlineStatus: $checkedConvert('onlineStatus',
              (v) => $enumDecodeNullable(_$UserOnlineStatusEnumMap, v)),
          pinnedNoteIds: $checkedConvert('pinnedNoteIds',
              (v) => (v as List<dynamic>?)?.map((e) => e as String).toList()),
          pinnedNotes: $checkedConvert(
              'pinnedNotes',
              (v) => (v as List<dynamic>?)
                  ?.map((e) => Note.fromJson(e as Map<String, dynamic>))
                  .toList()),
          pinnedPage: $checkedConvert(
              'pinnedPage',
              (v) =>
                  v == null ? null : Page.fromJson(v as Map<String, dynamic>)),
          pinnedPageId: $checkedConvert('pinnedPageId', (v) => v as String?),
          securityKeys: $checkedConvert('securityKeys', (v) => v as bool?),
          twoFactorEnabled:
              $checkedConvert('twoFactorEnabled', (v) => v as bool?),
          updatedAt: $checkedConvert('updatedAt',
              (v) => v == null ? null : DateTime.parse(v as String)),
          uri: $checkedConvert(
              'uri', (v) => v == null ? null : Uri.parse(v as String)),
          url: $checkedConvert(
              'url', (v) => v == null ? null : Uri.parse(v as String)),
          usePasswordLessLogin:
              $checkedConvert('usePasswordLessLogin', (v) => v as bool?),
        );
        return val;
      },
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'host': instance.host,
      'emojis': instance.emojis,
      'id': instance.id,
      'name': instance.name,
      'username': instance.username,
      'avatarUrl': instance.avatarUrl?.toString(),
      'avatarBlurhash': instance.avatarBlurhash,
      'isAdmin': instance.isAdmin,
      'isModerator': instance.isModerator,
      'isBot': instance.isBot,
      'isCat': instance.isCat,
      'onlineStatus': _$UserOnlineStatusEnumMap[instance.onlineStatus],
      'url': instance.url?.toString(),
      'uri': instance.uri?.toString(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'avatarId': instance.avatarId,
      'backgroundId': instance.backgroundId,
      'backgroundUrl': instance.backgroundUrl?.toString(),
      'bannerUrl': instance.bannerUrl?.toString(),
      'bannerBlurhash': instance.bannerBlurhash,
      'bannerId': instance.bannerId,
      'isLocked': instance.isLocked,
      'isSuspended': instance.isSuspended,
      'description': instance.description,
      'location': instance.location,
      'birthday': instance.birthday,
      'fields': instance.fields,
      'followersCount': instance.followersCount,
      'followingCount': instance.followingCount,
      'notesCount': instance.notesCount,
      'pinnedNoteIds': instance.pinnedNoteIds,
      'pinnedNotes': instance.pinnedNotes,
      'pinnedPageId': instance.pinnedPageId,
      'pinnedPage': instance.pinnedPage,
      'twoFactorEnabled': instance.twoFactorEnabled,
      'usePasswordLessLogin': instance.usePasswordLessLogin,
      'securityKeys': instance.securityKeys,
      'autoWatch': instance.autoWatch,
      'injectFeaturedNote': instance.injectFeaturedNote,
      'alwaysMarkNsfw': instance.alwaysMarkNsfw,
      'carefulBot': instance.carefulBot,
      'autoAcceptFollowed': instance.autoAcceptFollowed,
      'hasUnreadSpecifiedNotes': instance.hasUnreadSpecifiedNotes,
      'hasUnreadMentions': instance.hasUnreadMentions,
      'hasUnreadAnnouncement': instance.hasUnreadAnnouncement,
      'hasUnreadAntenna': instance.hasUnreadAntenna,
      'hasUnreadChannel': instance.hasUnreadChannel,
      'hasUnreadMessagingMessage': instance.hasUnreadMessagingMessage,
      'hasUnreadNotification': instance.hasUnreadNotification,
      'hasPendingReceivedFollowRequest':
          instance.hasPendingReceivedFollowRequest,
      'mutedWords': instance.mutedWords,
      'mutedInstances': instance.mutedInstances,
      'isFollowing': instance.isFollowing,
      'hasPendingFollowRequestFromYou': instance.hasPendingFollowRequestFromYou,
      'hasPendingFollowRequestToYou': instance.hasPendingFollowRequestToYou,
      'isFollowed': instance.isFollowed,
      'isBlocking': instance.isBlocking,
      'isBlocked': instance.isBlocked,
      'isMuted': instance.isMuted,
      'avatarDecorations': instance.avatarDecorations,
    };

const _$UserOnlineStatusEnumMap = {
  UserOnlineStatus.unknown: 'unknown',
  UserOnlineStatus.online: 'online',
  UserOnlineStatus.active: 'active',
  UserOnlineStatus.offline: 'offline',
};
