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
          id: $checkedConvert('id', (v) => v as String),
          following: $checkedConvert('following', (v) => v as bool),
          showingReblogs: $checkedConvert('showing_reblogs', (v) => v as bool),
          notifying: $checkedConvert('notifying', (v) => v as bool),
          followedBy: $checkedConvert('followed_by', (v) => v as bool),
          blocking: $checkedConvert('blocking', (v) => v as bool),
          muting: $checkedConvert('muting', (v) => v as bool),
          mutingNotifications:
              $checkedConvert('muting_notifications', (v) => v as bool),
          requested: $checkedConvert('requested', (v) => v as bool),
          domainBlocking: $checkedConvert('domain_blocking', (v) => v as bool),
          endorsed: $checkedConvert('endorsed', (v) => v as bool),
          note: $checkedConvert('note', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'showingReblogs': 'showing_reblogs',
        'followedBy': 'followed_by',
        'mutingNotifications': 'muting_notifications',
        'domainBlocking': 'domain_blocking'
      },
    );

Map<String, dynamic> _$RelationshipToJson(Relationship instance) =>
    <String, dynamic>{
      'id': instance.id,
      'following': instance.following,
      'showing_reblogs': instance.showingReblogs,
      'notifying': instance.notifying,
      'followed_by': instance.followedBy,
      'blocking': instance.blocking,
      'muting': instance.muting,
      'muting_notifications': instance.mutingNotifications,
      'requested': instance.requested,
      'domain_blocking': instance.domainBlocking,
      'endorsed': instance.endorsed,
      'note': instance.note,
    };
