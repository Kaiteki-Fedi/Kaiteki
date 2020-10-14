// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PleromaAccount _$PleromaAccountFromJson(Map<String, dynamic> json) {
  return PleromaAccount(
    json['accepts_chat_messages'] as bool,
    json['allow_following_move'] as bool,
    json['chat_token'] as String,
    json['confirmation_pending'] as bool,
    json['hide_favorites'] as bool,
    json['hide_followers'] as bool,
    json['hide_followers_count'] as bool,
    json['hide_follows'] as bool,
    json['hide_follows_count'] as bool,
    json['is_admin'] as bool,
    json['is_moderator'] as bool,
    json['notification_settings'] == null
        ? null
        : PleromaNotificationSettings.fromJson(
            json['notification_settings'] as Map<String, dynamic>),
    json['relationship'] == null
        ? null
        : PleromaRelationship.fromJson(
            json['relationship'] as Map<String, dynamic>),
    json['skip_thread_containment'] as bool,
    json['unread_conversation_count'] as int,
  );
}

Map<String, dynamic> _$PleromaAccountToJson(PleromaAccount instance) =>
    <String, dynamic>{
      'accepts_chat_messages': instance.acceptsChatMessages,
      'allow_following_move': instance.allowFollowingMove,
      'chat_token': instance.chatToken,
      'confirmation_pending': instance.confirmationPending,
      'hide_favorites': instance.hideFavorites,
      'hide_followers': instance.hideFollowers,
      'hide_followers_count': instance.hideFollowersCount,
      'hide_follows': instance.hideFollows,
      'hide_follows_count': instance.hideFollowsCount,
      'is_admin': instance.isAdmin,
      'is_moderator': instance.isModerator,
      'notification_settings': instance.notificationSettings,
      'relationship': instance.relationship,
      'skip_thread_containment': instance.skipThreadContainment,
      'unread_conversation_count': instance.unreadConversationCount,
    };
