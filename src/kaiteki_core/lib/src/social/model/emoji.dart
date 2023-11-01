abstract class Emoji {
  /// Short representation of the emoji, e.g. `thinking`
  String get short;

  /// Tag of this emoji, e.g. "blobcat" or "blobcat@instance.example"
  String get tag;

  /// Aliases of the emoji, used for searching, e.g. "think", "thoughtful", etc.
  List<String>? get aliases;

  const Emoji();

  /// String representation of the emoji (in logs or as fallback).
  @override
  String toString() => ':$tag:';

  /// Returns the tag of this emoji, but without the instance part if it's the
  /// same as the given [localInstance].
  String getTag([String? localInstance]) => tag;
}

class UnicodeEmoji extends Emoji {
  final String emoji;

  const UnicodeEmoji(this.emoji, [this.aliases = const []]);

  @override
  final List<String> aliases;

  @override
  String get short => emoji;

  @override
  String get tag => emoji;
}

class CustomEmoji extends Emoji {
  @override
  final String short;

  final Uri url;

  final String instance;

  @override
  final List<String>? aliases;

  const CustomEmoji({
    required this.short,
    required this.instance,
    this.aliases,
    required this.url,
  });

  factory CustomEmoji.parse(String tag, Uri url, String localInstance) {
    final parts = tag.split('@');
    final instance = parts.length > 1 ? parts[1] : null;

    return CustomEmoji(
      short: parts[0],
      instance: instance ?? localInstance,
      url: url,
    );
  }

  @override
  String get tag => '$short@$instance';

  @override
  String getTag([String? localInstance]) {
    return instance == localInstance ? short : tag;
  }
}
