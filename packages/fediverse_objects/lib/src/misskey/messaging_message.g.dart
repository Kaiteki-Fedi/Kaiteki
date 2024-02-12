// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messaging_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessagingMessage _$MessagingMessageFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'MessagingMessage',
      json,
      ($checkedConvert) {
        final val = MessagingMessage(
          id: $checkedConvert('id', (v) => v as String),
          createdAt:
              $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
          userId: $checkedConvert('userId', (v) => v as String),
          user: $checkedConvert(
              'user',
              (v) =>
                  v == null ? null : User.fromJson(v as Map<String, dynamic>)),
          text: $checkedConvert('text', (v) => v as String?),
          fileId: $checkedConvert('fileId', (v) => v as String?),
          file: $checkedConvert(
              'file',
              (v) => v == null
                  ? null
                  : DriveFile.fromJson(v as Map<String, dynamic>)),
          recipientId: $checkedConvert('recipientId', (v) => v as String?),
          recipient: $checkedConvert(
              'recipient',
              (v) =>
                  v == null ? null : User.fromJson(v as Map<String, dynamic>)),
          groupId: $checkedConvert('groupId', (v) => v as String?),
          group: $checkedConvert(
              'group',
              (v) => v == null
                  ? null
                  : UserGroup.fromJson(v as Map<String, dynamic>)),
          isRead: $checkedConvert('isRead', (v) => v as bool?),
          reads: $checkedConvert('reads',
              (v) => (v as List<dynamic>?)?.map((e) => e as String).toList()),
        );
        return val;
      },
    );

Map<String, dynamic> _$MessagingMessageToJson(MessagingMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'userId': instance.userId,
      'user': instance.user,
      'text': instance.text,
      'fileId': instance.fileId,
      'file': instance.file,
      'recipientId': instance.recipientId,
      'recipient': instance.recipient,
      'groupId': instance.groupId,
      'group': instance.group,
      'isRead': instance.isRead,
      'reads': instance.reads,
    };
