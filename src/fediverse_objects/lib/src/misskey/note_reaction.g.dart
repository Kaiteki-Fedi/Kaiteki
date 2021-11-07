// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_reaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoteReaction _$NoteReactionFromJson(Map<String, dynamic> json) => NoteReaction(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      type: json['type'] as String,
    );

Map<String, dynamic> _$NoteReactionToJson(NoteReaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'user': instance.user,
      'type': instance.type,
    };
