import 'package:json_annotation/json_annotation.dart';
import 'package:fediverse_objects/src/misskey/user.dart';
part 'note_reaction.g.dart';

@JsonSerializable()
class MisskeyNoteReaction {
  /// The unique identifier for this reaction.
  @JsonKey(name: 'id')
  final String id;
  
  /// The date that the reaction was created.
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;
  
  /// User who performed this reaction.
  @JsonKey(name: 'user')
  final MisskeyUser user;
  
  /// The reaction type.
  @JsonKey(name: 'type')
  final String type;
  
  const MisskeyNoteReaction({
    required this.id,
    required this.createdAt,
    required this.user,
    required this.type,
  });

  factory MisskeyNoteReaction.fromJson(Map<String, dynamic> json) => _$MisskeyNoteReactionFromJson(json);
  Map<String, dynamic> toJson() => _$MisskeyNoteReactionToJson(this);
}
