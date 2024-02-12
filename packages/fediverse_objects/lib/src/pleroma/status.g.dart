// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PleromaStatus _$PleromaStatusFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'PleromaStatus',
      json,
      ($checkedConvert) {
        final val = PleromaStatus(
          content: $checkedConvert(
              'content',
              (v) => (v as Map<String, dynamic>?)?.map(
                    (k, e) => MapEntry(k, e as String),
                  )),
          context: $checkedConvert('context', (v) => v as String?),
          conversationId: $checkedConvert('conversation_id', (v) => v as int?),
          directConversationId:
              $checkedConvert('direct_conversation_id', (v) => v as int?),
          emojiReactions: $checkedConvert(
              'emoji_reactions',
              (v) => (v as List<dynamic>?)
                  ?.map((e) => Reaction.fromJson(e as Map<String, dynamic>))
                  .toList()),
          expiresAt: $checkedConvert('expires_at',
              (v) => v == null ? null : DateTime.parse(v as String)),
          inReplyToAccountAcct:
              $checkedConvert('in_reply_to_account_acct', (v) => v as String?),
          local: $checkedConvert('local', (v) => v as bool),
          parentVisible: $checkedConvert('parent_visible', (v) => v as bool?),
          spoilerText: $checkedConvert(
              'spoiler_text',
              (v) => (v as Map<String, dynamic>?)?.map(
                    (k, e) => MapEntry(k, e as String),
                  )),
          threadMuted: $checkedConvert('thread_muted', (v) => v as bool?),
          pinnedAt: $checkedConvert('pinned_at',
              (v) => v == null ? null : DateTime.parse(v as String)),
        );
        return val;
      },
      fieldKeyMap: const {
        'conversationId': 'conversation_id',
        'directConversationId': 'direct_conversation_id',
        'emojiReactions': 'emoji_reactions',
        'expiresAt': 'expires_at',
        'inReplyToAccountAcct': 'in_reply_to_account_acct',
        'parentVisible': 'parent_visible',
        'spoilerText': 'spoiler_text',
        'threadMuted': 'thread_muted',
        'pinnedAt': 'pinned_at'
      },
    );

Map<String, dynamic> _$PleromaStatusToJson(PleromaStatus instance) =>
    <String, dynamic>{
      'content': instance.content,
      'context': instance.context,
      'conversation_id': instance.conversationId,
      'direct_conversation_id': instance.directConversationId,
      'emoji_reactions': instance.emojiReactions,
      'expires_at': instance.expiresAt?.toIso8601String(),
      'in_reply_to_account_acct': instance.inReplyToAccountAcct,
      'local': instance.local,
      'parent_visible': instance.parentVisible,
      'pinned_at': instance.pinnedAt?.toIso8601String(),
      'spoiler_text': instance.spoilerText,
      'thread_muted': instance.threadMuted,
    };
