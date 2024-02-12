import 'package:json_annotation/json_annotation.dart';
part 'emoji.g.dart';

@JsonSerializable()
class Emoji {
  final String? id;

  final List<String>? aliases;

  final String name;

  final String? category;

  /// The local host is represented with `null`.
  final String? host;

  final String url;

  const Emoji({
    this.id,
    this.aliases,
    required this.name,
    this.category,
    this.host,
    required this.url,
  });

  factory Emoji.fromJson(Map<String, dynamic> json) => _$EmojiFromJson(json);
  Map<String, dynamic> toJson() => _$EmojiToJson(this);
}
