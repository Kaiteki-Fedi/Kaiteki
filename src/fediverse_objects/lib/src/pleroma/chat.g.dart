// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PleromaChat _$PleromaChatFromJson(Map<String, dynamic> json) {
  return PleromaChat(
    MastodonAccount.fromJson(json['account'] as Map<String, dynamic>),
    json['id'] as String,
    PleromaChatMessage.fromJson(json['last_message'] as Map<String, dynamic>),
    json['unread'] as int,
    DateTime.parse(json['updated_at'] as String),
  );
}
