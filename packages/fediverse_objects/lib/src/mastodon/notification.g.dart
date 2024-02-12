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
          createdAt:
              $checkedConvert('created_at', (v) => DateTime.parse(v as String)),
          id: $checkedConvert('id', (v) => v as String),
          type: $checkedConvert('type', (v) => v as String),
          account: $checkedConvert(
              'account',
              (v) => v == null
                  ? null
                  : Account.fromJson(v as Map<String, dynamic>)),
          pleroma: $checkedConvert(
              'pleroma',
              (v) => v == null
                  ? null
                  : PleromaNotification.fromJson(v as Map<String, dynamic>)),
          status: $checkedConvert(
              'status',
              (v) => v == null
                  ? null
                  : Status.fromJson(v as Map<String, dynamic>)),
          emoji: $checkedConvert('emoji', (v) => v as String?),
          emojiUrl: $checkedConvert(
              'emoji_url', (v) => v == null ? null : Uri.parse(v as String)),
        );
        return val;
      },
      fieldKeyMap: const {'createdAt': 'created_at', 'emojiUrl': 'emoji_url'},
    );

Map<String, dynamic> _$NotificationToJson(Notification instance) =>
    <String, dynamic>{
      'account': instance.account,
      'created_at': instance.createdAt.toIso8601String(),
      'id': instance.id,
      'pleroma': instance.pleroma,
      'status': instance.status,
      'emoji': instance.emoji,
      'emoji_url': instance.emojiUrl?.toString(),
      'type': instance.type,
    };
