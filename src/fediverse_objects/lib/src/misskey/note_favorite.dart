import 'package:json_annotation/json_annotation.dart';
import 'package:fediverse_objects/src/misskey/note.dart';
part 'note_favorite.g.dart';

@JsonSerializable()
class MisskeyNoteFavorite {
  /// The unique identifier for this favorite.
  @JsonKey(name: 'id')
  final String id;
  
  /// The date that the favorite was created.
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;
  
  @JsonKey(name: 'note')
  final MisskeyNote note;
  
  @JsonKey(name: 'noteId')
  final String noteId;
  
  const MisskeyNoteFavorite({
    required this.id,
    required this.createdAt,
    required this.note,
    required this.noteId,
  });

  factory MisskeyNoteFavorite.fromJson(Map<String, dynamic> json) => _$MisskeyNoteFavoriteFromJson(json);
  Map<String, dynamic> toJson() => _$MisskeyNoteFavoriteToJson(this);
}
