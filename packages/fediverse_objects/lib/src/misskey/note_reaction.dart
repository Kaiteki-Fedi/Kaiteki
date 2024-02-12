import 'package:json_annotation/json_annotation.dart';
import 'user.dart';
part 'note_reaction.g.dart';

@JsonSerializable()
class NoteReaction {
  final String id;

  final DateTime createdAt;

  final User user;

  final String type;

  const NoteReaction({
    required this.id,
    required this.createdAt,
    required this.user,
    required this.type,
  });

  factory NoteReaction.fromJson(Map<String, dynamic> json) =>
      _$NoteReactionFromJson(json);
  Map<String, dynamic> toJson() => _$NoteReactionToJson(this);
}
