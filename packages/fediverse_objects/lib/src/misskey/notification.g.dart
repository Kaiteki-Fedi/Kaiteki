// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notification _$NotificationFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'Notification',
      json,
      ($checkedConvert) {
        final val = Notification(
          id: $checkedConvert('id', (v) => v as String),
          createdAt:
              $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
          isRead: $checkedConvert('isRead', (v) => v as bool?),
          type: $checkedConvert(
              'type', (v) => $enumDecode(_$NotificationTypeEnumMap, v)),
          user: $checkedConvert(
              'user',
              (v) =>
                  v == null ? null : User.fromJson(v as Map<String, dynamic>)),
          userId: $checkedConvert('userId', (v) => v as String?),
          note: $checkedConvert(
              'note',
              (v) =>
                  v == null ? null : Note.fromJson(v as Map<String, dynamic>)),
          reaction: $checkedConvert('reaction', (v) => v as String?),
          choice: $checkedConvert('choice', (v) => v as int?),
          invitation:
              $checkedConvert('invitation', (v) => v as Map<String, dynamic>?),
          body: $checkedConvert('body', (v) => v as String?),
          header: $checkedConvert('header', (v) => v as String?),
          icon: $checkedConvert('icon', (v) => v as String?),
        );
        return val;
      },
    );

Map<String, dynamic> _$NotificationToJson(Notification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'isRead': instance.isRead,
      'type': _$NotificationTypeEnumMap[instance.type]!,
      'user': instance.user,
      'userId': instance.userId,
      'note': instance.note,
      'reaction': instance.reaction,
      'choice': instance.choice,
      'invitation': instance.invitation,
      'body': instance.body,
      'header': instance.header,
      'icon': instance.icon,
    };

const _$NotificationTypeEnumMap = {
  NotificationType.achievementEarned: 'achievementEarned',
  NotificationType.app: 'app',
  NotificationType.follow: 'follow',
  NotificationType.followRequestAccepted: 'followRequestAccepted',
  NotificationType.groupInvited: 'groupInvited',
  NotificationType.mention: 'mention',
  NotificationType.note: 'note',
  NotificationType.pollEnded: 'pollEnded',
  NotificationType.pollVote: 'pollVote',
  NotificationType.quote: 'quote',
  NotificationType.reaction: 'reaction',
  NotificationType.receiveFollowRequest: 'receiveFollowRequest',
  NotificationType.renote: 'renote',
  NotificationType.reply: 'reply',
  NotificationType.test: 'test',
};
