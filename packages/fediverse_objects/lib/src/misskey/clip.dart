import 'package:json_annotation/json_annotation.dart';
import 'user.dart';
part 'clip.g.dart';

@JsonSerializable()
class Clip {
  final String id;

  final DateTime createdAt;

  final String userId;

  final User user;

  final String name;

  final String? description;

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
