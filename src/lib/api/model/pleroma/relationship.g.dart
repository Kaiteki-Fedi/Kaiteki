// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relationship.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PleromaRelationship _$PleromaRelationshipFromJson(Map<String, dynamic> json) {
  return PleromaRelationship(
    json['blocked_by'] as bool,
    json['blocking'] as bool,
    json['domain_blocking'] as bool,
    json['endorsed'] as bool,
    json['followed_by'] as bool,
    json['following'] as bool,
    json['id'] as String,
    json['muting'] as bool,
    json['muting_notifications'] as bool,
    json['requested'] as bool,
    json['showing_reblogs'] as bool,
    json['subscribing'] as bool,
  );
}
