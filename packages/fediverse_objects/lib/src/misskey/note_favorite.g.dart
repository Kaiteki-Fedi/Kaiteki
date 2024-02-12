// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_favorite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoteFavorite _$NoteFavoriteFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'NoteFavorite',
      json,
      ($checkedConvert) {
        final val = NoteFavorite(
          id: $checkedConvert('id', (v) => v as String),
          createdAt:
              $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
          note: $checkedConvert(
              'note', (v) => Note.fromJson(v as Map<String, dynamic>)),
          noteId: $checkedConvert('noteId', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$NoteFavoriteToJson(NoteFavorite instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'note': instance.note,
      'noteId': instance.noteId,
    };
