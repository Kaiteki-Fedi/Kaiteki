import "package:json_annotation/json_annotation.dart";

import "note.dart";

part "favorite.g.dart";

@JsonSerializable()
class Favorite {
  final String id;
  final DateTime createdAt;
  final Note note;
  final String noteId;

  const Favorite({
    required this.id,
    required this.createdAt,
    required this.note,
    required this.noteId,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) =>
      _$FavoriteFromJson(json);

  Map<String, dynamic> toJson() => _$FavoriteToJson(this);
}
