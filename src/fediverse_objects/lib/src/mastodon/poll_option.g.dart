// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poll_option.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MastodonPollOption _$MastodonPollOptionFromJson(Map<String, dynamic> json) {
  return MastodonPollOption(
    title: json['title'] as String,
    votesCount: json['votes_count'] as int,
  );
}

Map<String, dynamic> _$MastodonPollOptionToJson(MastodonPollOption instance) =>
    <String, dynamic>{
      'title': instance.title,
      'votes_count': instance.votesCount,
    };
