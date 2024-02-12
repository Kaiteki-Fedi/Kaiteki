import 'package:json_annotation/json_annotation.dart';

part 'relationship.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Relationship {
  final String id;
  final bool following;
  final bool showingReblogs;
  final bool notifying;
  final bool followedBy;
  final bool blocking;
  final bool muting;
  final bool mutingNotifications;
  final bool requested;
  final bool domainBlocking;
  final bool endorsed;
  final String? note;

  Relationship({
    required this.id,
    required this.following,
    required this.showingReblogs,
    required this.notifying,
    required this.followedBy,
    required this.blocking,
    required this.muting,
    required this.mutingNotifications,
    required this.requested,
    required this.domainBlocking,
    required this.endorsed,
    this.note,
  });

  factory Relationship.fromJson(Map<String, dynamic> json) =>
      _$RelationshipFromJson(json);

  Map<String, dynamic> toJson() => _$RelationshipToJson(this);
}
