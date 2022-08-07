import 'package:emojis/emoji.dart' as unicode_emoji;

abstract class Emoji {
  final String name;
  final Iterable<String>? aliases;

  const Emoji({
    required this.name,
    this.aliases,
  });
}

class UnicodeEmoji extends Emoji {
  const UnicodeEmoji({
    required super.name,
    super.aliases,
  });

  factory UnicodeEmoji.fromEmoji(unicode_emoji.Emoji emoji) {
    return UnicodeEmoji(
      name: emoji.char,
      aliases: emoji.keywords,
    );
  }

  @override
  String toString() => name;
}

class CustomEmoji extends Emoji {
  final String url;
  final String? instance;

  const CustomEmoji({
    required super.name,
    this.instance,
    super.aliases,
    required this.url,
  });

  @override
  String toString() => ":$name@$instance:";
}
