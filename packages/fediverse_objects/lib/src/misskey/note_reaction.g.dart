// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_reaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoteReaction _$NoteReactionFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'NoteReaction',
      json,
      ($checkedConvert) {
        final val = NoteReaction(
          id: $checkedConvert('id', (v) => v as String),
          createdAt:
              $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
          user: $checkedConvert(
              'user', (v) => User.fromJson(v as Map<String, dynamic>)),
          type: $checkedConvert('type', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$NoteReactionToJson(NoteReaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'user': instance.user,
      'type': instance.type,
    };
