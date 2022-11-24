abstract class Emoji {
  /// Short representation of the emoji, e.g. `thinking`
  String get short;

  /// Aliases of the emoji, used for searching, e.g. "think", "thoughtful", etc.
  List<String>? get aliases;

  const Emoji();

  /// String representation of the emoji (in logs or as fallback).
  @override
  String toString() => ":$short:";
}

class UnicodeEmoji extends Emoji {
  final String emoji;

  const UnicodeEmoji(this.emoji);

  @override
  // TODO(Craftplacer): implement aliases for unicode
  List<String>? get aliases => null;

  @override
  String get short => emoji;
}

class CustomEmoji extends Emoji {
  @override
  final String short;

  final String url;

  final String? instance;

  @override
  final List<String>? aliases;

  const CustomEmoji({
    required this.short,
    this.instance,
    this.aliases,
    required this.url,
  });

  @override
  String toString() {
    if (instance == null) return ":$short:";
    return ":$short@$instance:";
  }
}
