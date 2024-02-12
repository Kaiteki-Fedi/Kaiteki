// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => $checkedCreate(
      'ChatMessage',
      json,
      ($checkedConvert) {
        final val = ChatMessage(
          accountId: $checkedConvert('account_id', (v) => v as String),
          chatId: $checkedConvert('chat_id', (v) => v as String),
          createdAt:
              $checkedConvert('created_at', (v) => DateTime.parse(v as String)),
          emojis: $checkedConvert(
              'emojis',
              (v) => (v as List<dynamic>)
                  .map((e) => CustomEmoji.fromJson(e as Map<String, dynamic>))
                  .toList()),
          id: $checkedConvert('id', (v) => v as String),
          unread: $checkedConvert('unread', (v) => v as bool),
          attachment: $checkedConvert(
              'attachment',
              (v) => v == null
                  ? null
                  : MediaAttachment.fromJson(v as Map<String, dynamic>)),
          card: $checkedConvert(
              'card',
              (v) => v == null
                  ? null
                  : PreviewCard.fromJson(v as Map<String, dynamic>)),
          content: $checkedConvert('content', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'accountId': 'account_id',
        'chatId': 'chat_id',
        'createdAt': 'created_at'
      },
    );

Map<String, dynamic> _$ChatMessageToJson(ChatMessage instance) =>
    <String, dynamic>{
      'account_id': instance.accountId,
      'attachment': instance.attachment,
      'card': instance.card,
      'chat_id': instance.chatId,
      'content': instance.content,
      'created_at': instance.createdAt.toIso8601String(),
      'emojis': instance.emojis,
      'id': instance.id,
      'unread': instance.unread,
    };
