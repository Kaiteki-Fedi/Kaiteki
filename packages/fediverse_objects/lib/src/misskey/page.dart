import 'package:json_annotation/json_annotation.dart';
import 'user.dart';
part 'page.g.dart';

@JsonSerializable()
class Page {
  final String id;

  final DateTime createdAt;

  final DateTime updatedAt;

  final String title;

  final String name;

  final String? summary;

  final List<dynamic> content;

  final List<dynamic> variables;

  final String userId;

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
