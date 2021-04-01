import 'package:json_annotation/json_annotation.dart';
part 'emoji.g.dart';

@JsonSerializable()
class MisskeyEmoji {
  final String id;

  final Iterable<String> aliases;

  final String name;

  final String? category;

  final String? host;

  final String url;

  const MisskeyEmoji({
    required this.id,
    required this.aliases,
    required this.name,
    required this.category,
    required this.host,
    required this.url,
  });

  factory MisskeyEmoji.fromJson(Map<String, dynamic> json) =>
      _$MisskeyEmojiFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyEmojiToJson(this);
}
