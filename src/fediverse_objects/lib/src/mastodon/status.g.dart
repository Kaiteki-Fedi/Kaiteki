// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Status _$StatusFromJson(Map<String, dynamic> json) {
  return Status(
    account: Account.fromJson(json['account'] as Map<String, dynamic>),
    application: json['application'] == null
        ? null
        : Application.fromJson(json['application'] as Map<String, dynamic>),
    content: json['content'] as String,
    createdAt: DateTime.parse(json['created_at'] as String),
    emojis: (json['emojis'] as List<dynamic>)
        .map((e) => Emoji.fromJson(e as Map<String, dynamic>)),
    favouritesCount: json['favourites_count'] as int,
    id: json['id'] as String,
    mediaAttachments: (json['media_attachments'] as List<dynamic>)
        .map((e) => Attachment.fromJson(e as Map<String, dynamic>)),
    mentions: (json['mentions'] as List<dynamic>)
        .map((e) => Mention.fromJson(e as Map<String, dynamic>)),
    reblogsCount: json['reblogs_count'] as int,
    repliesCount: json['replies_count'] as int,
    sensitive: json['sensitive'] as bool,
    spoilerText: json['spoiler_text'] as String,
    tags: (json['tags'] as List<dynamic>)
        .map((e) => Tag.fromJson(e as Map<String, dynamic>)),
    uri: json['uri'] as String,
    visibility: json['visibility'] as String,
    bookmarked: json['bookmarked'] as bool?,
    card: json['card'] == null
        ? null
        : Card.fromJson(json['card'] as Map<String, dynamic>),
    favourited: json['favourited'] as bool?,
    inReplyToAccountId: json['in_reply_to_account_id'] as String?,
    inReplyToId: json['in_reply_to_id'] as String?,
    language: json['language'] as String?,
    muted: json['muted'] as bool?,
    pinned: json['pinned'] as bool?,
    pleroma: json['pleroma'] == null
        ? null
        : p.Status.fromJson(json['pleroma'] as Map<String, dynamic>),
    reblog: json['reblog'] == null
        ? null
        : Status.fromJson(json['reblog'] as Map<String, dynamic>),
    reblogged: json['reblogged'] as bool?,
    url: json['url'] as String?,
    text: json['text'] as String?,
    poll: json['poll'] == null
        ? null
        : Poll.fromJson(json['poll'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$StatusToJson(Status instance) => <String, dynamic>{
      'account': instance.account,
      'application': instance.application,
      'bookmarked': instance.bookmarked,
      'card': instance.card,
      'content': instance.content,
      'created_at': instance.createdAt.toIso8601String(),
      'emojis': instance.emojis.toList(),
      'favourited': instance.favourited,
      'favourites_count': instance.favouritesCount,
      'id': instance.id,
      'in_reply_to_account_id': instance.inReplyToAccountId,
      'in_reply_to_id': instance.inReplyToId,
      'language': instance.language,
      'media_attachments': instance.mediaAttachments.toList(),
      'mentions': instance.mentions.toList(),
      'muted': instance.muted,
      'pinned': instance.pinned,
      'pleroma': instance.pleroma,
      'reblog': instance.reblog,
      'reblogged': instance.reblogged,
      'reblogs_count': instance.reblogsCount,
      'replies_count': instance.repliesCount,
      'poll': instance.poll,
      'sensitive': instance.sensitive,
      'spoiler_text': instance.spoilerText,
      'tags': instance.tags.toList(),
      'uri': instance.uri,
      'url': instance.url,
      'visibility': instance.visibility,
      'text': instance.text,
    };
