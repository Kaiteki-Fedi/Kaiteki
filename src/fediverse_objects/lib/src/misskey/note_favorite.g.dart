// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_favorite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyNoteFavorite _$MisskeyNoteFavoriteFromJson(Map<String, dynamic> json) {
  return MisskeyNoteFavorite(
    id: json['id'] as String,
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt'] as String),
    note: json['note'] == null
        ? null
        : MisskeyNote.fromJson(json['note'] as Map<String, dynamic>),
    noteId: json['noteId'] as String,
  );
}

Map<String, dynamic> _$MisskeyNoteFavoriteToJson(
        MisskeyNoteFavorite instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt?.toIso8601String(),
      'note': instance.note,
      'noteId': instance.noteId,
    };
