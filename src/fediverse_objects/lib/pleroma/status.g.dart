// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PleromaStatus _$PleromaStatusFromJson(Map<String, dynamic> json) {
  return PleromaStatus(
    (json['content'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    ),
    json['conversation_id'] as int,
    (json['emoji_reactions'] as List)?.map((e) => e == null
        ? null
        : PleromaEmojiReaction.fromJson(e as Map<String, dynamic>)),
    json['expires_at'] == null
        ? null
        : DateTime.parse(json['expires_at'] as String),
    json['in_reply_to_account_acct'] as String,
    json['local'] as bool,
    json['parent_visible'] as bool,
    json['thread_muted'] as bool,
  );
}
