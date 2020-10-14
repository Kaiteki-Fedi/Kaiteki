import 'package:json_annotation/json_annotation.dart';
part 'emoji.g.dart';

@JsonSerializable()
class MisskeyEmoji {
  final String id;

  final Iterable<String> aliases;

  final String name;

  final String category;

  final String host;

  final String url;

  const MisskeyEmoji({
    this.id,
    this.aliases,
    this.name,
    this.category,
    this.host,
    this.url,
  });

  factory MisskeyEmoji.fromJson(Map<String, dynamic> json) => _$MisskeyEmojiFromJson(json);
}