import 'package:json_annotation/json_annotation.dart';
import 'note.dart';
part 'note_favorite.g.dart';

@JsonSerializable()
class NoteFavorite {
  final String id;

  final DateTime createdAt;

  final Note note;

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
