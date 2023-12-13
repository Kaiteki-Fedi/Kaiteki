import 'package:json_annotation/json_annotation.dart';

part 'emoji.g.dart';

@JsonSerializable(createToJson: false)
class Emoji {
  final List<int> base;
  final List<List<int>> alternates;
  final List<String> emoticons;
  final List<String> shortcodes;

  const Emoji({
    required this.base,
    required this.alternates,
    required this.emoticons,
    required this.shortcodes,
  });

  factory Emoji.fromJson(Map<String, dynamic> json) => _$EmojiFromJson(json);
}
