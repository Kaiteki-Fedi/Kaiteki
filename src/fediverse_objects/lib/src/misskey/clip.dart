import 'package:fediverse_objects/src/misskey/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'clip.g.dart';

@JsonSerializable()
class Clip {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'createdAt')
  final DateTime createdAt;

  @JsonKey(name: 'userId')
  final String userId;

  @JsonKey(name: 'user')
  final User user;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'description')
  final String? description;

  @JsonKey(name: 'isPublic')
  final bool isPublic;

  const Clip({
    required this.id,
    required this.createdAt,
    required this.userId,
    required this.user,
    required this.name,
    this.description,
    required this.isPublic,
  });

  factory Clip.fromJson(Map<String, dynamic> json) => _$ClipFromJson(json);

  Map<String, dynamic> toJson() => _$ClipToJson(this);
}
