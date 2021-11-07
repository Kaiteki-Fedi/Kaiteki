import 'package:fediverse_objects/src/misskey/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'page.g.dart';

@JsonSerializable()
class Page {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'createdAt')
  final DateTime createdAt;

  @JsonKey(name: 'updatedAt')
  final DateTime updatedAt;

  @JsonKey(name: 'title')
  final String title;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'summary')
  final String? summary;

  @JsonKey(name: 'content')
  final Iterable<dynamic> content;

  @JsonKey(name: 'variables')
  final Iterable<dynamic> variables;

  @JsonKey(name: 'userId')
  final String userId;

  @JsonKey(name: 'user')
  final User user;

  const Page({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.title,
    required this.name,
    this.summary,
    required this.content,
    required this.variables,
    required this.userId,
    required this.user,
  });

  factory Page.fromJson(Map<String, dynamic> json) => _$PageFromJson(json);

  Map<String, dynamic> toJson() => _$PageToJson(this);
}
