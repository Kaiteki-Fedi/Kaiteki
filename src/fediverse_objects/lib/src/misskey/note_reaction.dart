import 'package:fediverse_objects/src/misskey/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'note_reaction.g.dart';

@JsonSerializable()
class NoteReaction {
  /// The unique identifier for this reaction.
  @JsonKey(name: 'id')
  final String id;

  /// The date that the reaction was created.
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;

  /// User who performed this reaction.
  @JsonKey(name: 'user')
  final User user;

  /// The reaction type.
  @JsonKey(name: 'type')
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
