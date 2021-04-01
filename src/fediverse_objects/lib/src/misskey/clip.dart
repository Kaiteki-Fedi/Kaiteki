import 'package:json_annotation/json_annotation.dart';
import 'package:fediverse_objects/src/misskey/user.dart';
part 'clip.g.dart';

@JsonSerializable()
class MisskeyClip {
  /// The unique identifier for this Clip.
  @JsonKey(name: 'id')
  final String id;
  
  /// The date that the Clip was created.
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;
  
  @JsonKey(name: 'userId')
  final String userId;
  
  @JsonKey(name: 'user')
  final MisskeyUser user;
  
  /// The name of the Clip.
  @JsonKey(name: 'name')
  final String name;
  
  /// The description of the Clip.
  @JsonKey(name: 'description')
  final String description;
  
  /// Whether this Clip is public.
  @JsonKey(name: 'isPublic')
  final bool isPublic;
  
  const MisskeyClip({
    required this.id,
    required this.createdAt,
    required this.userId,
    required this.user,
    required this.name,
    required this.description,
    required this.isPublic,
  });

  factory MisskeyClip.fromJson(Map<String, dynamic> json) => _$MisskeyClipFromJson(json);
  Map<String, dynamic> toJson() => _$MisskeyClipToJson(this);
}
