import "dart:ui";

import "package:equatable/equatable.dart";
import "package:kaiteki/text/parsers/text_parser.dart";
import "package:kaiteki_core/model.dart";
import "package:kaiteki_core/utils.dart";

abstract class Element extends Equatable {
  String? get allText {
    switch (this) {
      case WrapElement():
        final buffer = StringBuffer(safeCast<TextElement>()?.text ?? "");
        final children = (this as WrapElement).children ?? const [];
        for (final child in children) {
          buffer.write(child);
        }
        return buffer.toString();
      case TextElement():
        return (this as TextElement).text;
      default:
        return null;
    }
  }

  const Element();

  bool has(bool Function(Element element) predicate) {
    return predicate(this) ||
        (this is WrapElement &&
            (this as WrapElement).children?.any(predicate) == true);
  }
}

abstract class WrapElement extends Element {
  final List<Element>? children;

  const WrapElement({this.children});

  @override
  List<Object?> get props => [children];

  WrapElement replaceChildren(List<Element>? children);
}

typedef ReplacementElementBuilder = List<Element> Function(String text);

class TextStyleElement extends WrapElement {
  final TextElementStyle style;

  const TextStyleElement(this.style, [List<Element>? children])
      : super(children: children);

  @override
  List<Object?> get props => [style, children];

  @override
  WrapElement replaceChildren(List<Element>? children) {
    return TextStyleElement(style, children);
  }
}

class TextElement extends Element {
  final String text;

  const TextElement(this.text);

  @override
  String toString() {
    return "Text ($text)";
  }

  @override
  List<Object?> get props => [text];
}

extension TextElementExtension on TextElement {
  List<Element> cut(int index, int length, ReplacementElementBuilder builder) {
    final text = this.text;

    String? start;
    String? middle;
    String? end;

    if (index >= 1) {
      start = text.substring(0, index);
    }

    middle = text.substring(index, index + length);

    final endIndex = index + length;
    if (endIndex < text.length) {
      end = text.substring(endIndex, text.length);
    }

    return [
      if (start != null) TextElement(start),
      ...builder(middle),
      if (end != null) TextElement(end),
    ];
  }
}

class TextElementStyle {
  static const TextElementStyle kBold = TextElementStyle(bold: true);
  static const TextElementStyle kItalic = TextElementStyle(italic: true);
  static const TextElementStyle kMonospace =
      TextElementStyle(font: TextElementFont.monospace);

  final Color? foreground;
  final Color? background;
  final bool? bold;
  final bool? italic;
  final TextElementFont? font;
  final double? scale;
  final bool? blur;

  const TextElementStyle({
    this.bold,
    this.italic,
    this.scale,
    this.font,
    this.blur,
    this.background,
    this.foreground,
  });

  TextElementStyle copyWith({
    bool? bold,
    bool? italic,
    TextElementFont? font,
    double? scale,
    bool? blur,
  }) {
    return TextElementStyle(
      bold: bold ?? this.bold,
      italic: italic ?? this.italic,
      font: font ?? this.font,
      scale: scale ?? this.scale,
      blur: blur ?? this.blur,
    );
  }

  TextElementStyle merge(TextElementStyle? other) {
    if (other == null) return this;

    return copyWith(
      bold: other.bold,
      italic: other.italic,
      font: other.font,
      scale: other.scale,
      blur: other.blur,
    );
  }
}

enum TextElementFont {
  normal,
  monospace,
}

class LinkElement extends WrapElement {
  final Uri destination;

  const LinkElement(
    this.destination, {
    super.children,
  });

  @override
  String toString() => "Link ($destination)";

  @override
  List<Object?> get props => [destination];

  @override
  WrapElement replaceChildren(List<Element>? children) {
    return LinkElement(destination, children: children);
  }
}

class MentionElement extends Element {
  final UserReference reference;

  const MentionElement(this.reference);

  @override
  String toString() => reference.toString();

  @override
  List<Object?> get props => [reference];
}

class HashtagElement extends Element {
  final String name;

  const HashtagElement(this.name);

  @override
  String toString() => "Hashtag";

  @override
  List<Object?> get props => [name];
}

class EmojiElement extends Element {
  final String name;

  const EmojiElement(this.name);

  @override
  String toString() => "Emoji (:$name:)";

  @override
  List<Object?> get props => [name];
}

extension ElementExtensions on Element {
  String get allText {
    var initalText = "";
    if (this is TextElement) {
      final elementText = (this as TextElement).text;
      initalText = elementText;
    }

    final buffer = StringBuffer(initalText);

    final children = safeCast<WrapElement>()?.children ?? const [];
    for (final child in children) {
      buffer.write(child.allText);
    }

    return buffer.toString();
  }
}

extension ElementIterableExtensions on Iterable<Element> {
  Iterable<Element> parseWith(TextParser parser) sync* {
    for (final element in this) {
      yield* parser.parseElement(element);
    }
  }
}
