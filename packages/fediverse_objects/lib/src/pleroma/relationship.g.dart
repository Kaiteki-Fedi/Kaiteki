// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relationship.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Relationship _$RelationshipFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'Relationship',
      json,
      ($checkedConvert) {
        final val = Relationship(
          $checkedConvert('blocked_by', (v) => v as bool?),
          $checkedConvert('blocking', (v) => v as bool?),
          $checkedConvert('domain_blocking', (v) => v as bool?),
          $checkedConvert('endorsed', (v) => v as bool?),
          $checkedConvert('followed_by', (v) => v as bool?),
          $checkedConvert('following', (v) => v as bool?),
          $checkedConvert('id', (v) => v as String?),
          $checkedConvert('muting', (v) => v as bool?),
          $checkedConvert('muting_notifications', (v) => v as bool?),
          $checkedConvert('requested', (v) => v as bool?),
          $checkedConvert('showing_reblogs', (v) => v as bool?),
          $checkedConvert('subscribing', (v) => v as bool?),
        );
        return val;
      },
      fieldKeyMap: const {
        'blockedBy': 'blocked_by',
        'domainBlocking': 'domain_blocking',
        'followedBy': 'followed_by',
        'mutingNotifications': 'muting_notifications',
        'showingReblogs': 'showing_reblogs'
      },
    );

Map<String, dynamic> _$RelationshipToJson(Relationship instance) =>
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
