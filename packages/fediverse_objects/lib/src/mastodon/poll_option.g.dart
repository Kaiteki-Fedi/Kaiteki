// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poll_option.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PollOption _$PollOptionFromJson(Map<String, dynamic> json) => $checkedCreate(
      'PollOption',
      json,
      ($checkedConvert) {
        final val = PollOption(
          title: $checkedConvert('title', (v) => v as String),
          votesCount: $checkedConvert('votes_count', (v) => v as int?),
        );
        return val;
      },
      fieldKeyMap: const {'votesCount': 'votes_count'},
    );

Map<String, dynamic> _$PollOptionToJson(PollOption instance) =>
    <String, dynamic>{
      'title': instance.title,
      'votes_count': instance.votesCount,
    };
