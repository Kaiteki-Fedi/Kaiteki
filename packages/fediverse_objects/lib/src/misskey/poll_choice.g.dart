// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poll_choice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PollChoice _$PollChoiceFromJson(Map<String, dynamic> json) => $checkedCreate(
      'PollChoice',
      json,
      ($checkedConvert) {
        final val = PollChoice(
          text: $checkedConvert('text', (v) => v as String),
          votes: $checkedConvert('votes', (v) => v as int),
          isVoted: $checkedConvert('isVoted', (v) => v as bool),
        );
        return val;
      },
    );

Map<String, dynamic> _$PollChoiceToJson(PollChoice instance) =>
    <String, dynamic>{
      'text': instance.text,
      'votes': instance.votes,
      'isVoted': instance.isVoted,
    };
