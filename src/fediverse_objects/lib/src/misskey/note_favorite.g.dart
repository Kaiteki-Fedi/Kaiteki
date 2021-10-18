// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_favorite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoteFavorite _$NoteFavoriteFromJson(Map<String, dynamic> json) {
  return NoteFavorite(
    id: json['id'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
    note: Note.fromJson(json['note'] as Map<String, dynamic>),
    noteId: json['noteId'] as String,
  );
}

Map<String, dynamic> _$NoteFavoriteToJson(NoteFavorite instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'note': instance.note,
      'noteId': instance.noteId,
    };
