// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poll.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyPoll _$MisskeyPollFromJson(Map<String, dynamic> json) {
  return MisskeyPoll(
    multiple: json['multiple'] as bool,
    expiresAt: json['expiresAt'] == null
        ? null
        : DateTime.parse(json['expiresAt'] as String),
    choices: (json['choices'] as List)?.map((e) => e == null
        ? null
        : MisskeyPollChoice.fromJson(e as Map<String, dynamic>)),
  );
}

Map<String, dynamic> _$MisskeyPollToJson(MisskeyPoll instance) =>
    <String, dynamic>{
      'multiple': instance.multiple,
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'choices': instance.choices?.toList(),
    };
