import 'package:fediverse_objects/src/misskey/note.dart';
import 'package:json_annotation/json_annotation.dart';

part 'note_favorite.g.dart';

@JsonSerializable()
class NoteFavorite {
  /// The unique identifier for this favorite.
  @JsonKey(name: 'id')
  final String id;

  /// The date that the favorite was created.
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;

  @JsonKey(name: 'note')
  final Note note;

  @JsonKey(name: 'noteId')
  final String noteId;

  const NoteFavorite({
    required this.id,
    required this.createdAt,
    required this.note,
    required this.noteId,
  });

  factory NoteFavorite.fromJson(Map<String, dynamic> json) =>
      _$NoteFavoriteFromJson(json);
  Map<String, dynamic> toJson() => _$NoteFavoriteToJson(this);
}
