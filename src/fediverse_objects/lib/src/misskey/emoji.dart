import 'package:json_annotation/json_annotation.dart';

part 'emoji.g.dart';

@JsonSerializable()
class Emoji {
  final String id;

  final Iterable<String> aliases;

  final String name;

  final String? category;

  final String? host;

  final String url;

  const Emoji({
    required this.id,
    required this.aliases,
    required this.name,
    required this.category,
    required this.host,
    required this.url,
  });

  factory Emoji.fromJson(Map<String, dynamic> json) => _$EmojiFromJson(json);

  Map<String, dynamic> toJson() => _$EmojiToJson(this);
}
