import "package:collection/collection.dart";
import "package:kaiteki/text/elements.dart";

abstract class TextParser {
  Iterable<Element> parse(String text);
}

extension TextParserExtensions on TextParser {
  Iterable<Element> parseElement(Element element) sync* {
    if (element is TextElement) {
      yield* parse(element.text);
    } else if (element is WrapElement) {
      final parsedChildren =
          element.children?.map(parseElement).flattened.toList();
      yield element.replaceChildren(parsedChildren);
    } else {
      yield element;
    }
  }
}
