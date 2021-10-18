// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chat _$ChatFromJson(Map<String, dynamic> json) {
  return Chat(
    mastodon.Account.fromJson(json['account'] as Map<String, dynamic>),
    json['id'] as String,
    ChatMessage.fromJson(json['last_message'] as Map<String, dynamic>),
    json['unread'] as int,
    DateTime.parse(json['updated_at'] as String),
  );
}
