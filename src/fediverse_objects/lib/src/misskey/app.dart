import 'package:json_annotation/json_annotation.dart';
part 'app.g.dart';

@JsonSerializable()
class MisskeyApp {
  @JsonKey(name: 'id')
  final String id;
  
  @JsonKey(name: 'name')
  final String name;
  
  @JsonKey(name: 'createdAt')
  final String createdAt;
  
  @JsonKey(name: 'lastUsedAt')
  final String lastUsedAt;
  
  @JsonKey(name: 'permission')
  final Iterable<String> permission;
  
  @JsonKey(name: 'secret')
  final String secret;
  
  @JsonKey(name: 'isAuthorized')
  final bool isAuthorized;
  
  const MisskeyApp({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.lastUsedAt,
    required this.permission,
    required this.secret,
    required this.isAuthorized,
  });

  factory MisskeyApp.fromJson(Map<String, dynamic> json) => _$MisskeyAppFromJson(json);
  Map<String, dynamic> toJson() => _$MisskeyAppToJson(this);
}
