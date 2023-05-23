import "package:equatable/equatable.dart";
import "package:kaiteki/fediverse/model/user/reference.dart";
import "package:kaiteki/text/parsers/text_parser.dart";
import "package:kaiteki/utils/extensions.dart";

abstract class Element extends Equatable {
  final List<Element>? children;

  final String? text;

  String get allText {
    final buffer = StringBuffer(text ?? "");

    final children = this.children;

    if (children != null) {
      for (final child in children) {
        buffer.write(child.allText);
      }
    }

    return buffer.toString();
  }

  const Element({this.text, this.children});

  bool has(bool Function(Element element) predicate) {
    return predicate(this) || children?.any(predicate) == true;
  }
}

typedef ReplacementElementBuilder = Element Function(String text);

class TextElement extends Element {
  final TextElementStyle? style;

  const TextElement(
    String? text, {
    this.style,
    super.children,
  }) : super(text: text);

  List<Element> cut(int index, int length, ReplacementElementBuilder builder) {
    final text = this.text;

    if (text == null) {
      return [];
    }

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
      builder(middle),
      if (end != null) TextElement(end),
    ];
  }

  TextElement cutAsElement(
    int index,
    int length,
    ReplacementElementBuilder builder,
  ) {
    final children = this.children;
    Iterable<Element> newChildren = cut(index, length, builder);

    if (children != null) {
      newChildren = newChildren.followedBy(children);
    }

    return TextElement(
      null,
      style: style,
      children: newChildren.toList(growable: false),
    );
  }

  @override
  String toString() {
    return "Text ($text)";
  }

  @override
  List<Object?> get props => [text];
}

class TextElementStyle {
  final bool bold;
  final bool italic;
  final TextElementFont font;
  final double? scale;
  final bool blur;

  const TextElementStyle({
    this.bold = false,
    this.italic = false,
    this.scale,
    this.font = TextElementFont.normal,
    this.blur = false,
  });
}

enum TextElementFont {
  normal,
  monospace,
}

class LinkElement extends Element {
  final Uri destination;

  const LinkElement(
    this.destination, {
    super.children,
  });

  @override
  String toString() => "Link ($destination)";

  @override
  List<Object?> get props => [destination];
}

class MentionElement extends Element {
  final UserReference reference;

  MentionElement(this.reference) : super(text: reference.handle);

  @override
  String toString() => "Mention";

  @override
  List<Object?> get props => [reference];
}

class HashtagElement extends Element {
  final String name;

  const HashtagElement(this.name) : super(text: "#$name");

  @override
  String toString() => "Hashtag";

  @override
  List<Object?> get props => [name];
}

class EmojiElement extends Element {
  final String name;

  const EmojiElement(this.name) : super(text: ":$name:");

  @override
  String toString() => "Emoji (:$name:)";

  @override
  List<Object?> get props => [name];
}

extension ElementExtensions on Element {
  String get allText {
    var initalText = "";
    if (this is TextElement && (this as TextElement).text != null) {
      final elementText = (this as TextElement).text;
      if (elementText != null) {
        initalText = elementText;
      }
    }

    final buffer = StringBuffer(initalText);

    final children = this.children;
    if (children != null) {
      for (final child in children) {
        buffer.write(child.allText);
      }
    }

    return buffer.toString();
  }
}

extension ElementListExtensions on List<Element> {
  List<Element> parseWith(TextParser parser) {
    return map(parser.parseElement).concat().toList();
  }
}
