// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poll.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MastodonPoll _$MastodonPollFromJson(Map<String, dynamic> json) {
  return MastodonPoll(
    emojis: (json['emojis'] as List)?.map((e) =>
        e == null ? null : MastodonEmoji.fromJson(e as Map<String, dynamic>)),
    expired: json['expired'] as bool,
    expiresAt: json['expires_at'] == null
        ? null
        : DateTime.parse(json['expires_at'] as String),
    id: json['id'] as String,
    multiple: json['multiple'] as bool,
    options: json['options'] as List,
    ownVotes: (json['own_votes'] as List)?.map((e) => e as int),
    voted: json['voted'] as bool,
    votersCount: json['voters_count'],
    votesCount: json['votes_count'] as int,
  );
}

Map<String, dynamic> _$MastodonPollToJson(MastodonPoll instance) =>
    <String, dynamic>{
      'emojis': instance.emojis?.toList(),
      'expired': instance.expired,
      'expires_at': instance.expiresAt?.toIso8601String(),
      'id': instance.id,
      'multiple': instance.multiple,
      'options': instance.options?.toList(),
      'own_votes': instance.ownVotes?.toList(),
      'voted': instance.voted,
      'voters_count': instance.votersCount,
      'votes_count': instance.votesCount,
    };
