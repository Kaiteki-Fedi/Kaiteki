// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'federation_instance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FederationInstance _$FederationInstanceFromJson(Map<String, dynamic> json) {
  return FederationInstance(
    id: json['id'] as String,
    caughtAt: DateTime.parse(json['caughtAt'] as String),
    host: json['host'] as String,
    usersCount: json['usersCount'] as int,
    notesCount: json['notesCount'] as int,
    followingCount: json['followingCount'] as int,
    followersCount: json['followersCount'] as int,
    driveUsage: json['driveUsage'] as int,
    driveFiles: json['driveFiles'] as int,
    latestRequestSentAt: DateTime.parse(json['latestRequestSentAt'] as String),
    lastCommunicatedAt: DateTime.parse(json['lastCommunicatedAt'] as String),
    isNotResponding: json['isNotResponding'] as bool,
    isSuspended: json['isSuspended'] as bool,
    softwareName: json['softwareName'] as String,
    softwareVersion: json['softwareVersion'] as String,
    openRegistrations: json['openRegistrations'] as bool,
    name: json['name'] as String,
    description: json['description'] as String,
    maintainerName: json['maintainerName'] as String,
    maintainerEmail: json['maintainerEmail'] as String,
    iconUrl: json['iconUrl'] as String,
    infoUpdatedAt: DateTime.parse(json['infoUpdatedAt'] as String),
  );
}

Map<String, dynamic> _$FederationInstanceToJson(FederationInstance instance) =>
    <String, dynamic>{
      'id': instance.id,
      'caughtAt': instance.caughtAt.toIso8601String(),
      'host': instance.host,
      'usersCount': instance.usersCount,
      'notesCount': instance.notesCount,
      'followingCount': instance.followingCount,
      'followersCount': instance.followersCount,
      'driveUsage': instance.driveUsage,
      'driveFiles': instance.driveFiles,
      'latestRequestSentAt': instance.latestRequestSentAt.toIso8601String(),
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
      'infoUpdatedAt': instance.infoUpdatedAt.toIso8601String(),
    };
