// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_reaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyNoteReaction _$MisskeyNoteReactionFromJson(Map<String, dynamic> json) {
  return MisskeyNoteReaction(
    id: json['id'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
    user: MisskeyUser.fromJson(json['user'] as Map<String, dynamic>),
    type: json['type'] as String,
  );
}

Map<String, dynamic> _$MisskeyNoteReactionToJson(
        MisskeyNoteReaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'user': instance.user,
      'type': instance.type,
    };
