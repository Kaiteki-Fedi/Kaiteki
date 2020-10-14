// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PleromaChat _$PleromaChatFromJson(Map<String, dynamic> json) {
  return PleromaChat(
    json['account'] == null
        ? null
        : MastodonAccount.fromJson(json['account'] as Map<String, dynamic>),
    json['id'] as String,
    json['last_message'] == null
        ? null
        : PleromaChatMessage.fromJson(
            json['last_message'] as Map<String, dynamic>),
    json['unread'] as int,
    json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
  );
}

Map<String, dynamic> _$PleromaChatToJson(PleromaChat instance) =>
    <String, dynamic>{
      'account': instance.account,
      'id': instance.id,
      'last_message': instance.lastMessage,
      'unread': instance.unread,
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
