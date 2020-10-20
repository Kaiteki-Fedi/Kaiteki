// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PleromaChatMessage _$PleromaChatMessageFromJson(Map<String, dynamic> json) {
  return PleromaChatMessage(
    accountId: json['account_id'] as String,
    attachment: json['attachment'] == null
        ? null
        : MastodonMediaAttachment.fromJson(
            json['attachment'] as Map<String, dynamic>),
    card: json['card'] == null
        ? null
        : MastodonCard.fromJson(json['card'] as Map<String, dynamic>),
    chatId: json['chat_id'] as String,
    content: json['content'] as String,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    emojis: (json['emojis'] as List)?.map((e) =>
        e == null ? null : MastodonEmoji.fromJson(e as Map<String, dynamic>)),
    id: json['id'] as String,
  );
}
