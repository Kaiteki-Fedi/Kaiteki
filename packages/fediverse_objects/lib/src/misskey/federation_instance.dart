import 'package:json_annotation/json_annotation.dart';
part 'federation_instance.g.dart';

@JsonSerializable()
class FederationInstance {
  final String id;

  final DateTime caughtAt;

  final String host;

  final int usersCount;

  final int notesCount;

  final int followingCount;

  final int followersCount;

  final DateTime? latestRequestSentAt;

  final DateTime lastCommunicatedAt;

  final bool isNotResponding;

  final bool isSuspended;

  final String? softwareName;

  final String? softwareVersion;

  final bool? openRegistrations;

  final String? name;

  final String? description;

  final String? maintainerName;

  final String? maintainerEmail;

  final String? iconUrl;

  final DateTime? infoUpdatedAt;

  const FederationInstance({
    required this.id,
    required this.caughtAt,
    required this.host,
    required this.usersCount,
    required this.notesCount,
    required this.followingCount,
    required this.followersCount,
    this.latestRequestSentAt,
    required this.lastCommunicatedAt,
    required this.isNotResponding,
    required this.isSuspended,
    this.softwareName,
    this.softwareVersion,
    this.openRegistrations,
    this.name,
    this.description,
    this.maintainerName,
    this.maintainerEmail,
    this.iconUrl,
    this.infoUpdatedAt,
  });

  factory FederationInstance.fromJson(Map<String, dynamic> json) =>
      _$FederationInstanceFromJson(json);
  Map<String, dynamic> toJson() => _$FederationInstanceToJson(this);
}
