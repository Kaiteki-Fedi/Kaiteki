import 'package:json_annotation/json_annotation.dart';

part 'channel.g.dart';

@JsonSerializable()
class Channel {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'createdAt')
  final DateTime createdAt;

  @JsonKey(name: 'lastNotedAt')
  final DateTime? lastNotedAt;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'description')
  final String? description;

  @JsonKey(name: 'bannerUrl')
  final String? bannerUrl;

  @JsonKey(name: 'notesCount')
  final int notesCount;

  @JsonKey(name: 'usersCount')
  final int usersCount;

  @JsonKey(name: 'isFollowing')
  final bool? isFollowing;

  @JsonKey(name: 'userId')
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
    required this.isFollowing,
    this.userId,
  });

  factory Channel.fromJson(Map<String, dynamic> json) =>
      _$ChannelFromJson(json);

  Map<String, dynamic> toJson() => _$ChannelToJson(this);
}
