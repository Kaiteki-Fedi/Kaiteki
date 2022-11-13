abstract class Emoji<T> {
  final T? source;

  /// The name of the emoji, usually the text between the two colons.
  final String name;

  /// The aliases of the emoji.
  final Iterable<String>? aliases;

  /// Whether the emoji will be added to the user's emoji selector.
  final bool visibleInPicker;

  const Emoji({
    required this.source,
    required this.name,
    this.aliases,
    this.visibleInPicker = false,
  });
}

class UnicodeEmoji extends Emoji<String> {
  const UnicodeEmoji(
    String emoji,
    String name, {
    super.aliases,
  }) : super(
          source: emoji,
          name: name,
          visibleInPicker: true,
        );
}

class CustomEmoji<T> extends Emoji<T> {
  /// The URL of the image that represents this emoji.
  final String url;

  const CustomEmoji({
    super.source,
    required super.name,
    super.aliases,
    required this.url,
  });

  @override
  String toString() => ":$name:";
}
