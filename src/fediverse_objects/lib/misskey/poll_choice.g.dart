// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poll_choice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyPollChoice _$MisskeyPollChoiceFromJson(Map<String, dynamic> json) {
  return MisskeyPollChoice(
    text: json['text'] as String,
    votes: json['votes'] as int,
    isVoted: json['isVoted'] as bool,
  );
}

Map<String, dynamic> _$MisskeyPollChoiceToJson(MisskeyPollChoice instance) =>
    <String, dynamic>{
      'text': instance.text,
      'votes': instance.votes,
      'isVoted': instance.isVoted,
    };
