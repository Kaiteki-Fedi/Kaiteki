import 'package:json_annotation/json_annotation.dart';
part 'relationship.g.dart';

@JsonSerializable()
class PleromaRelationship {
  @JsonKey(name: "blocked_by")
  final bool blockedBy;

  final bool blocking;

  @JsonKey(name: "domain_blocking")
  final bool domainBlocking;

  final bool endorsed;

  @JsonKey(name: "followed_by")
  final bool followedBy;

  final bool following;

  final String id;

  final bool muting;

  @JsonKey(name: "muting_notifications")
  final bool mutingNotifications;

  final bool requested;

  @JsonKey(name: "showing_reblogs")
  final bool showingReblogs;

  final bool subscribing;

  const PleromaRelationship(
    this.blockedBy,
    this.blocking,
    this.domainBlocking,
    this.endorsed,
    this.followedBy,
    this.following,
    this.id,
    this.muting,
    this.mutingNotifications,
    this.requested,
    this.showingReblogs,
    this.subscribing,
  );

  factory PleromaRelationship.fromJson(Map<String, dynamic> json) => _$PleromaRelationshipFromJson(json);
}