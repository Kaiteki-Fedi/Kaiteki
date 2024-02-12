// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'federation_instance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FederationInstance _$FederationInstanceFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'FederationInstance',
      json,
      ($checkedConvert) {
        final val = FederationInstance(
          id: $checkedConvert('id', (v) => v as String),
          caughtAt:
              $checkedConvert('caughtAt', (v) => DateTime.parse(v as String)),
          host: $checkedConvert('host', (v) => v as String),
          usersCount: $checkedConvert('usersCount', (v) => v as int),
          notesCount: $checkedConvert('notesCount', (v) => v as int),
          followingCount: $checkedConvert('followingCount', (v) => v as int),
          followersCount: $checkedConvert('followersCount', (v) => v as int),
          latestRequestSentAt: $checkedConvert('latestRequestSentAt',
              (v) => v == null ? null : DateTime.parse(v as String)),
          lastCommunicatedAt: $checkedConvert(
              'lastCommunicatedAt', (v) => DateTime.parse(v as String)),
          isNotResponding: $checkedConvert('isNotResponding', (v) => v as bool),
          isSuspended: $checkedConvert('isSuspended', (v) => v as bool),
          softwareName: $checkedConvert('softwareName', (v) => v as String?),
          softwareVersion:
              $checkedConvert('softwareVersion', (v) => v as String?),
          openRegistrations:
              $checkedConvert('openRegistrations', (v) => v as bool?),
          name: $checkedConvert('name', (v) => v as String?),
          description: $checkedConvert('description', (v) => v as String?),
          maintainerName:
              $checkedConvert('maintainerName', (v) => v as String?),
          maintainerEmail:
              $checkedConvert('maintainerEmail', (v) => v as String?),
          iconUrl: $checkedConvert('iconUrl', (v) => v as String?),
          infoUpdatedAt: $checkedConvert('infoUpdatedAt',
              (v) => v == null ? null : DateTime.parse(v as String)),
        );
        return val;
      },
    );

Map<String, dynamic> _$FederationInstanceToJson(FederationInstance instance) =>
    <String, dynamic>{
      'id': instance.id,
      'caughtAt': instance.caughtAt.toIso8601String(),
      'host': instance.host,
      'usersCount': instance.usersCount,
      'notesCount': instance.notesCount,
      'followingCount': instance.followingCount,
      'followersCount': instance.followersCount,
      'latestRequestSentAt': instance.latestRequestSentAt?.toIso8601String(),
      'lastCommunicatedAt': instance.lastCommunicatedAt.toIso8601String(),
      'isNotResponding': instance.isNotResponding,
      'isSuspended': instance.isSuspended,
      'softwareName': instance.softwareName,
      'softwareVersion': instance.softwareVersion,
      'openRegistrations': instance.openRegistrations,
      'name': instance.name,
      'description': instance.description,
      'maintainerName': instance.maintainerName,
      'maintainerEmail': instance.maintainerEmail,
      'iconUrl': instance.iconUrl,
      'infoUpdatedAt': instance.infoUpdatedAt?.toIso8601String(),
    };
