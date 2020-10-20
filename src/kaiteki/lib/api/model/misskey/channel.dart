import 'package:json_annotation/json_annotation.dart';
part 'channel.g.dart';

@JsonSerializable(createToJson: false)
class MisskeyChannel {
  final String id;

  final DateTime createdAt;

  final DateTime lastNotedAt;

  final String name;

  final String description;

  final String bannerUrl;

  final int notesCount;

  final int usersCount;

  final bool isFollowing;

  final String userId;

  const MisskeyChannel({
    this.id,
    this.createdAt,
    this.lastNotedAt,
    this.name,
    this.description,
    this.bannerUrl,
    this.notesCount,
    this.usersCount,
    this.isFollowing,
    this.userId,
  });

  factory MisskeyChannel.fromJson(Map<String, dynamic> json) => _$MisskeyChannelFromJson(json);
}