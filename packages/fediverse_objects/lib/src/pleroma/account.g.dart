// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PleromaAccount _$PleromaAccountFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'PleromaAccount',
      json,
      ($checkedConvert) {
        final val = PleromaAccount(
          acceptsChatMessages:
              $checkedConvert('accepts_chat_messages', (v) => v as bool?),
          allowFollowingMove:
              $checkedConvert('allow_following_move', (v) => v as bool?),
          chatToken: $checkedConvert('chat_token', (v) => v as String?),
          confirmationPending:
              $checkedConvert('confirmation_pending', (v) => v as bool?),
          hideFavorites: $checkedConvert('hide_favorites', (v) => v as bool),
          hideFollowers: $checkedConvert('hide_followers', (v) => v as bool),
          hideFollowersCount:
              $checkedConvert('hide_followers_count', (v) => v as bool),
          hideFollows: $checkedConvert('hide_follows', (v) => v as bool),
          hideFollowsCount:
              $checkedConvert('hide_follows_count', (v) => v as bool),
          isAdmin: $checkedConvert('is_admin', (v) => v as bool?),
          isModerator: $checkedConvert('is_moderator', (v) => v as bool?),
          isConfirmed: $checkedConvert('is_confirmed', (v) => v as bool?),
          notificationSettings: $checkedConvert(
              'notification_settings',
              (v) => v == null
                  ? null
                  : NotificationSettings.fromJson(v as Map<String, dynamic>)),
          relationship: $checkedConvert(
              'relationship',
              (v) => v == null
                  ? null
                  : Relationship.fromJson(v as Map<String, dynamic>)),
          skipThreadContainment:
              $checkedConvert('skip_thread_containment', (v) => v as bool),
          unreadConversationCount:
              $checkedConvert('unread_conversation_count', (v) => v as int?),
          favicon: $checkedConvert(
              'favicon', (v) => v == null ? null : Uri.parse(v as String)),
          settingsStore: $checkedConvert(
              'settings_store', (v) => v as Map<String, dynamic>?),
          alsoKnownAs: $checkedConvert('also_known_as',
              (v) => (v as List<dynamic>).map((e) => e as String).toList()),
          backgroundImage: $checkedConvert('background_image',
              (v) => v == null ? null : Uri.parse(v as String)),
          birthday: $checkedConvert('birthday',
              (v) => v == null ? null : DateTime.parse(v as String)),
          tags: $checkedConvert('tags',
              (v) => (v as List<dynamic>).map((e) => e as String).toList()),
          unreadNotificationsCount:
              $checkedConvert('unread_notifications_count', (v) => v as int?),
          deactivated: $checkedConvert('deactivated', (v) => v as bool?),
          apId: $checkedConvert('ap_id', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'acceptsChatMessages': 'accepts_chat_messages',
        'allowFollowingMove': 'allow_following_move',
        'chatToken': 'chat_token',
        'confirmationPending': 'confirmation_pending',
        'hideFavorites': 'hide_favorites',
        'hideFollowers': 'hide_followers',
        'hideFollowersCount': 'hide_followers_count',
        'hideFollows': 'hide_follows',
        'hideFollowsCount': 'hide_follows_count',
        'isAdmin': 'is_admin',
        'isModerator': 'is_moderator',
        'isConfirmed': 'is_confirmed',
        'notificationSettings': 'notification_settings',
        'skipThreadContainment': 'skip_thread_containment',
        'unreadConversationCount': 'unread_conversation_count',
        'settingsStore': 'settings_store',
        'alsoKnownAs': 'also_known_as',
        'backgroundImage': 'background_image',
        'unreadNotificationsCount': 'unread_notifications_count',
        'apId': 'ap_id'
      },
    );

Map<String, dynamic> _$PleromaAccountToJson(PleromaAccount instance) =>
    <String, dynamic>{
      'accepts_chat_messages': instance.acceptsChatMessages,
      'allow_following_move': instance.allowFollowingMove,
      'also_known_as': instance.alsoKnownAs,
      'background_image': instance.backgroundImage?.toString(),
      'birthday': instance.birthday?.toIso8601String(),
      'favicon': instance.favicon?.toString(),
      'chat_token': instance.chatToken,
      'confirmation_pending': instance.confirmationPending,
      'hide_favorites': instance.hideFavorites,
      'hide_followers': instance.hideFollowers,
      'hide_followers_count': instance.hideFollowersCount,
      'hide_follows': instance.hideFollows,
      'hide_follows_count': instance.hideFollowsCount,
      'is_admin': instance.isAdmin,
      'is_moderator': instance.isModerator,
      'is_confirmed': instance.isConfirmed,
      'notification_settings': instance.notificationSettings,
      'relationship': instance.relationship,
      'settings_store': instance.settingsStore,
      'skip_thread_containment': instance.skipThreadContainment,
      'tags': instance.tags,
      'unread_conversation_count': instance.unreadConversationCount,
      'unread_notifications_count': instance.unreadNotificationsCount,
      'deactivated': instance.deactivated,
      'ap_id': instance.apId,
    };
