// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relationship.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PleromaRelationship _$PleromaRelationshipFromJson(Map<String, dynamic> json) {
  return PleromaRelationship(
    json['blocked_by'] as bool?,
    json['blocking'] as bool?,
    json['domain_blocking'] as bool?,
    json['endorsed'] as bool?,
    json['followed_by'] as bool?,
    json['following'] as bool?,
    json['id'] as String?,
    json['muting'] as bool?,
    json['muting_notifications'] as bool?,
    json['requested'] as bool?,
    json['showing_reblogs'] as bool?,
    json['subscribing'] as bool?,
  );
}

Map<String, dynamic> _$PleromaRelationshipToJson(
        PleromaRelationship instance) =>
    <String, dynamic>{
      'blocked_by': instance.blockedBy,
      'blocking': instance.blocking,
      'domain_blocking': instance.domainBlocking,
      'endorsed': instance.endorsed,
      'followed_by': instance.followedBy,
      'following': instance.following,
      'id': instance.id,
      'muting': instance.muting,
      'muting_notifications': instance.mutingNotifications,
      'requested': instance.requested,
      'showing_reblogs': instance.showingReblogs,
      'subscribing': instance.subscribing,
    };
