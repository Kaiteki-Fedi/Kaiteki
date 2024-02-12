// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poll.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Poll _$PollFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Poll',
      json,
      ($checkedConvert) {
        final val = Poll(
          id: $checkedConvert('id', (v) => v as String),
          expiresAt: $checkedConvert('expires_at',
              (v) => v == null ? null : DateTime.parse(v as String)),
          expired: $checkedConvert('expired', (v) => v as bool),
          multiple: $checkedConvert('multiple', (v) => v as bool),
          emojis: $checkedConvert(
              'emojis',
              (v) => (v as List<dynamic>)
                  .map((e) => CustomEmoji.fromJson(e as Map<String, dynamic>))
                  .toList()),
          options: $checkedConvert(
              'options',
              (v) => (v as List<dynamic>)
                  .map((e) => PollOption.fromJson(e as Map<String, dynamic>))
                  .toList()),
          ownVotes: $checkedConvert('own_votes',
              (v) => (v as List<dynamic>?)?.map((e) => e as int).toList()),
          voted: $checkedConvert('voted', (v) => v as bool?),
          votersCount: $checkedConvert('voters_count', (v) => v as int?),
          votesCount: $checkedConvert('votes_count', (v) => v as int),
        );
        return val;
      },
      fieldKeyMap: const {
        'expiresAt': 'expires_at',
        'ownVotes': 'own_votes',
        'votersCount': 'voters_count',
        'votesCount': 'votes_count'
      },
    );

Map<String, dynamic> _$PollToJson(Poll instance) => <String, dynamic>{
      'emojis': instance.emojis,
      'expired': instance.expired,
      'expires_at': instance.expiresAt?.toIso8601String(),
      'id': instance.id,
      'multiple': instance.multiple,
      'options': instance.options,
      'own_votes': instance.ownVotes,
      'voted': instance.voted,
      'voters_count': instance.votersCount,
      'votes_count': instance.votesCount,
    };
