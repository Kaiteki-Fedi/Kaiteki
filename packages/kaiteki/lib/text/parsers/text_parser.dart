import "package:kaiteki/text/elements.dart";

abstract class TextParser {
  Iterable<Element> parse(String text);
}

extension TextParserExtensions on TextParser {
  Iterable<Element> parseElement(Element element) sync* {
    switch (element) {
      case TextElement():
        yield* parse(element.text);
      case WrapElement():
        yield element.replaceChildren(
          element.children?.expand(parseElement).toList(),
        );
      default:
        yield element;
    }
  }
}
