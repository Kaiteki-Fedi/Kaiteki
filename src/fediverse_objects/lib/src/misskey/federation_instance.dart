import 'package:json_annotation/json_annotation.dart';

part 'federation_instance.g.dart';

@JsonSerializable()
class FederationInstance {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'caughtAt')
  final DateTime caughtAt;

  @JsonKey(name: 'host')
  final String host;

  @JsonKey(name: 'usersCount')
  final int usersCount;

  @JsonKey(name: 'notesCount')
  final int notesCount;

  @JsonKey(name: 'followingCount')
  final int followingCount;

  @JsonKey(name: 'followersCount')
  final int followersCount;

  @JsonKey(name: 'driveUsage')
  final int driveUsage;

  @JsonKey(name: 'driveFiles')
  final int driveFiles;

  @JsonKey(name: 'latestRequestSentAt')
  final DateTime latestRequestSentAt;

  @JsonKey(name: 'lastCommunicatedAt')
  final DateTime lastCommunicatedAt;

  @JsonKey(name: 'isNotResponding')
  final bool isNotResponding;

  @JsonKey(name: 'isSuspended')
  final bool isSuspended;

  @JsonKey(name: 'softwareName')
  final String softwareName;

  @JsonKey(name: 'softwareVersion')
  final String softwareVersion;

  @JsonKey(name: 'openRegistrations')
  final bool openRegistrations;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'description')
  final String description;

  @JsonKey(name: 'maintainerName')
  final String maintainerName;

  @JsonKey(name: 'maintainerEmail')
  final String maintainerEmail;

  @JsonKey(name: 'iconUrl')
  final String iconUrl;

  @JsonKey(name: 'infoUpdatedAt')
  final DateTime infoUpdatedAt;

  const FederationInstance({
    required this.id,
    required this.caughtAt,
    required this.host,
    required this.usersCount,
    required this.notesCount,
    required this.followingCount,
    required this.followersCount,
    required this.driveUsage,
    required this.driveFiles,
    required this.latestRequestSentAt,
    required this.lastCommunicatedAt,
    required this.isNotResponding,
    required this.isSuspended,
    required this.softwareName,
    required this.softwareVersion,
    required this.openRegistrations,
    required this.name,
    required this.description,
    required this.maintainerName,
    required this.maintainerEmail,
    required this.iconUrl,
    required this.infoUpdatedAt,
  });

  factory FederationInstance.fromJson(Map<String, dynamic> json) =>
      _$FederationInstanceFromJson(json);
  Map<String, dynamic> toJson() => _$FederationInstanceToJson(this);
}
