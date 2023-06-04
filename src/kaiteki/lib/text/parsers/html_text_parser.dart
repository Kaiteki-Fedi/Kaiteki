import "package:collection/collection.dart";
import "package:html/dom.dart" as dom;
import "package:html/parser.dart" show parseFragment;
import "package:kaiteki/text/elements.dart";
import "package:kaiteki/text/parsers.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/model.dart";
import "package:logging/logging.dart";

typedef HtmlElementConstructor = List<Element>? Function(
  dom.Element element,
  List<Element> subElements,
);

class HtmlTextParser implements TextParser {
  static final _logger = Logger("HtmlTextParser");

  @override
  List<Element> parse(String text, [List<Element>? children]) {
    final fragment = parseFragment(text);
    return fragment.nodes.map(renderNode).flattened.toList(growable: false);
  }

  static const Map<String, HtmlElementConstructor> htmlConstructors = {
    "a": _renderLink,
    "b": _renderBold,
    "br": _renderBreakLine,
    "code": _renderCodeFont,
    "em": _renderItalic,
    "i": _renderItalic,
    "p": _renderParagraph,
    "pre": _renderCodeFont,
    "span": _renderNoop,
    "strong": _renderBold,
  };

  const HtmlTextParser();

  List<Element> renderNode(dom.Node node) {
    final renderedSubNodes = node.nodes //
        .map(renderNode)
        .flattened
        .toList(growable: false);

    if (node is dom.Element) {
      final override = renderNodeOverride(node);
      if (override != null) return [override];

      final tag = node.localName!.toLowerCase();
      final constructor = htmlConstructors[tag];
      if (constructor != null) {
        final rendered = constructor.call(node, renderedSubNodes);
        if (rendered != null) return rendered;
        _logger.warning("Couldn't render HTML tag ($tag)");
      } else {
        _logger.warning("Unhandled HTML tag ($tag)");
      }
    }

    if (node is dom.Text) {
      return [if (node.data.isNotEmpty) TextElement(node.text)];
    }

    return renderedSubNodes;
  }

  Element? renderNodeOverride(dom.Node node) => null;

  static List<Element>? _renderLink(
    dom.Element element,
    List<Element> subElements,
  ) {
    final href = element.attributes["href"];
    if (href == null) return null;
    final uri = Uri.parse(href);
    return [LinkElement(uri, children: subElements)];
  }

  static List<Element> _renderBreakLine(dom.Element _, List<Element> __) {
    return [const TextElement("\n")];
  }

  static List<Element> _renderCodeFont(
    dom.Element element,
    List<Element> subElements,
  ) {
    return [
      TextElement(
        null,
        style: const TextElementStyle(font: TextElementFont.monospace),
        children: subElements,
      )
    ];
  }

  static List<Element> _renderItalic(
    dom.Element element,
    List<Element> subElements,
  ) {
    return [
      TextElement(
        null,
        style: const TextElementStyle(italic: true),
        children: subElements,
      )
    ];
  }

  static List<Element> _renderBold(
    dom.Element element,
    List<Element> subElements,
  ) {
    return [
      TextElement(
        null,
        style: const TextElementStyle(bold: true),
        children: subElements,
      )
    ];
  }

  static List<Element> _renderParagraph(
    dom.Element element,
    List<Element> subElements,
  ) {
    var text = "";

    if (element.previousElementSibling?.localName?.toLowerCase() == "p") {
      text = "\n\n$text";
    }

    return [TextElement(text, children: subElements)];
  }

  static List<Element> _renderNoop(dom.Element _, List<Element> subElements) {
    return subElements;
  }
}

class MastodonHtmlTextParser extends HtmlTextParser {
  const MastodonHtmlTextParser();

  @override
  Element? renderNodeOverride(dom.Node node) {
    if (node.hasClass("h-card")) {
      final link = node.firstChild;

      if (link != null) {
        final result = renderNodeOverride(link);
        if (result != null) return result;
      }
    }

    if (node.hasClass("hashtag")) {
      final name = node.attributes["data-tag"];
      if (name != null) return HashtagElement(name);

      final nameSpan = node.children
          .firstWhereOrNull((child) => child.localName == "span")
          ?.text;
      if (nameSpan != null) return HashtagElement(nameSpan);
    }

    final url = node.attributes["href"];
    if (url != null) {
      if (node.hasClass("mention")) {
        return MentionElement(UserReference.url(url));
      }
    }

    return null;
  }
}
