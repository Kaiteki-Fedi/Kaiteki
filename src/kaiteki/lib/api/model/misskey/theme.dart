import 'package:json_annotation/json_annotation.dart';

class MisskeyTheme {
  final String name;

  final String author;

  @JsonKey(name: "desc")
  final String description;

  final String base;

  final String id;

  const MisskeyTheme({
    this.name,
    this.author,
    this.description,
    this.base,
    this.id,
  });
}
