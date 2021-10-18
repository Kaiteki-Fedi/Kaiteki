import 'package:json_annotation/json_annotation.dart';

part 'app.g.dart';

@JsonSerializable()
class App {
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

  const App({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.lastUsedAt,
    required this.permission,
    required this.secret,
    required this.isAuthorized,
  });

  factory App.fromJson(Map<String, dynamic> json) => _$AppFromJson(json);
  Map<String, dynamic> toJson() => _$AppToJson(this);
}
