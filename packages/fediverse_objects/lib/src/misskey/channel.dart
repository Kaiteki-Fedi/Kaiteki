import 'package:json_annotation/json_annotation.dart';
part 'channel.g.dart';

@JsonSerializable()
class Channel {
  final String id;

  final DateTime createdAt;

  final DateTime? lastNotedAt;

  final String name;

  final String? description;

  final String? bannerUrl;

  final int notesCount;

  final int usersCount;

  final bool? isFollowing;

  final String? userId;

  const Channel({
    required this.id,
    required this.createdAt,
    this.lastNotedAt,
    required this.name,
    this.description,
    this.bannerUrl,
    required this.notesCount,
    required this.usersCount,
    this.isFollowing,
    this.userId,
  });

  factory Channel.fromJson(Map<String, dynamic> json) =>
      _$ChannelFromJson(json);
  Map<String, dynamic> toJson() => _$ChannelToJson(this);
}
