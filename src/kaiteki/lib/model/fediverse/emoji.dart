import 'package:flutter/foundation.dart';

abstract class Emoji<T> {
  final T source;

  /// The name of the emoji, usually the text between the two colons.
  final String name;

  /// The aliases of the emoji.
  final Iterable<String> aliases;

  /// Whether the emoji will be added to the user's emoji selector.
  final bool visibleInPicker;

  const Emoji({
    @required this.source,
    @required this.name,
    this.aliases,
    this.visibleInPicker = false
  });
}

class UnicodeEmoji extends Emoji<String> {
  const UnicodeEmoji(
    String emoji,
    String name,
    {Iterable<String> aliases}
  ) : super(source: emoji, name: name, aliases: aliases, visibleInPicker: true);
}

class CustomEmoji<T> extends Emoji<T> {
  /// The URL of the image that represents this emoji.
  final String url;

  const CustomEmoji({T source, String name, Iterable<String> aliases, this.url})
    : super(source: source, name: name, aliases: aliases);
}