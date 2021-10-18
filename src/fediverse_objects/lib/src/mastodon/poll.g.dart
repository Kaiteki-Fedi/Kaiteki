// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poll.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Poll _$PollFromJson(Map<String, dynamic> json) {
  return Poll(
    id: json['id'] as String,
    expiresAt: json['expires_at'] == null
        ? null
        : DateTime.parse(json['expires_at'] as String),
    expired: json['expired'] as bool,
    multiple: json['multiple'] as bool,
    emojis: (json['emojis'] as List<dynamic>)
        .map((e) => Emoji.fromJson(e as Map<String, dynamic>)),
    options: (json['options'] as List<dynamic>)
        .map((e) => PollOption.fromJson(e as Map<String, dynamic>)),
    ownVotes: (json['own_votes'] as List<dynamic>?)?.map((e) => e as int),
    voted: json['voted'] as bool?,
    votersCount: json['voters_count'] as int?,
    votesCount: json['votes_count'] as int,
  );
}

Map<String, dynamic> _$PollToJson(Poll instance) => <String, dynamic>{
      'emojis': instance.emojis.toList(),
      'expired': instance.expired,
      'expires_at': instance.expiresAt?.toIso8601String(),
      'id': instance.id,
      'multiple': instance.multiple,
      'options': instance.options.toList(),
      'own_votes': instance.ownVotes?.toList(),
      'voted': instance.voted,
      'voters_count': instance.votersCount,
      'votes_count': instance.votesCount,
    };
