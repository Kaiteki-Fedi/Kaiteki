import "package:collection/collection.dart";
import "package:html/dom.dart" as dom;
import "package:html/parser.dart" show parseFragment;
import "package:kaiteki/text/elements.dart";
import "package:kaiteki/text/parsers.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/model.dart";
import "package:logging/logging.dart";

typedef HtmlElementConstructor = Iterable<Element> Function(
  dom.Element element,
  List<Element> subElements,
);

class HtmlTextParser implements TextParser {
  static final _logger = Logger("HtmlTextParser");

  @override
  Iterable<Element> parse(String text) sync* {
    for (final node in parseFragment(text).nodes) {
      yield* renderNode(node);
    }
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
    "li": _renderListItem,
  };

  const HtmlTextParser();

  Iterable<Element> renderNode(dom.Node node) sync* {
    final renderedSubNodes = node.nodes //
        .map(renderNode)
        .flattened
        .toList(growable: false);

    if (node is dom.Text && node.data.isNotEmpty) {
      yield TextElement(node.text);
      return;
    }

    if (node is dom.Element) {
      final override = renderNodeOverride(node);
      if (override != null) {
        yield override;
        return;
      }

      final tag = node.localName!.toLowerCase();
      final constructor = htmlConstructors[tag];
      if (constructor == null) {
        _logger.warning("Unhandled HTML tag ($tag)");
      } else {
        yield* constructor.call(node, renderedSubNodes);
        return;
      }
    }

    yield* renderedSubNodes;
  }

  Element? renderNodeOverride(dom.Node node) => null;

  static Iterable<Element> _renderLink(
    dom.Element element,
    List<Element> subElements,
  ) sync* {
    final href = element.attributes["href"];
    if (href == null) {
      yield* subElements;
    } else {
      final uri = Uri.parse(href);
      yield LinkElement(uri, children: subElements);
    }
  }

  static Iterable<Element> _renderBreakLine(
    dom.Element _,
    List<Element> __,
  ) sync* {
    yield const TextElement("\n");
  }

  static Iterable<Element> _renderCodeFont(
    dom.Element element,
    List<Element> children,
  ) sync* {
    yield TextStyleElement(TextElementStyle.kMonospace, children);
  }

  static Iterable<Element> _renderItalic(
    dom.Element element,
    List<Element> children,
  ) sync* {
    yield TextStyleElement(TextElementStyle.kItalic, children);
  }

  static Iterable<Element> _renderBold(
    dom.Element element,
    List<Element> children,
  ) sync* {
    yield TextStyleElement(TextElementStyle.kBold, children);
  }

  static Iterable<Element> _renderParagraph(
    dom.Element element,
    List<Element> children,
  ) sync* {
    // fake margin
    if (element.previousElementSibling?.localName?.toLowerCase() == "p") {
      yield const TextElement("\n\n");
    }

    yield* children;
  }

  static Iterable<Element> _renderListItem(
    dom.Element element,
    List<Element> subElements,
  ) sync* {
    yield TextElement("$kBullet ${element.text}\n");
  }

  static Iterable<Element> _renderNoop(
    dom.Element _,
    List<Element> children,
  ) sync* {
    yield* children;
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
