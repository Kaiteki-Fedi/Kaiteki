import 'package:json_annotation/json_annotation.dart';
part 'channel.g.dart';

@JsonSerializable()
class MisskeyChannel {
  /// The unique identifier for this Channel.
  @JsonKey(name: 'id')
  final String id;
  
  /// The date that the Channel was created.
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;
  
  @JsonKey(name: 'lastNotedAt')
  final DateTime lastNotedAt;
  
  /// The name of the Channel.
  @JsonKey(name: 'name')
  final String name;
  
  @JsonKey(name: 'description')
  final String description;
  
  @JsonKey(name: 'bannerUrl')
  final String bannerUrl;
  
  @JsonKey(name: 'notesCount')
  final int notesCount;
  
  @JsonKey(name: 'usersCount')
  final int usersCount;
  
  @JsonKey(name: 'isFollowing')
  final bool isFollowing;
  
  @JsonKey(name: 'userId')
  final String userId;
  
  const MisskeyChannel({
    required this.id,
    required this.createdAt,
    required this.lastNotedAt,
    required this.name,
    required this.description,
    required this.bannerUrl,
    required this.notesCount,
    required this.usersCount,
    required this.isFollowing,
    required this.userId,
  });

  factory MisskeyChannel.fromJson(Map<String, dynamic> json) => _$MisskeyChannelFromJson(json);
  Map<String, dynamic> toJson() => _$MisskeyChannelToJson(this);
}
