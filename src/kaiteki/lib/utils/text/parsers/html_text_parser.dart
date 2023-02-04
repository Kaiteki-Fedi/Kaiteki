import "package:collection/collection.dart";
import "package:html/dom.dart" as dom;
import "package:html/parser.dart" show parseFragment;
import "package:kaiteki/fediverse/model/user/reference.dart";
import "package:kaiteki/logger.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki/utils/text/elements.dart";
import "package:kaiteki/utils/text/parsers.dart";

typedef HtmlElementConstructor = List<Element>? Function(
  dom.Element element,
  List<Element> subElements,
);

class HtmlTextParser implements TextParser {
  static final _logger = getLogger("HtmlTextParser");

  @override
  List<Element> parse(String text, [List<Element>? children]) {
    final fragment = parseFragment(text);
    return fragment.nodes.map(renderNode).flattened.toList(growable: false);
  }

  static const Map<String, HtmlElementConstructor> htmlConstructors = {
    "a": _renderLink,
    "br": _renderBreakLine,
    "pre": _renderCodeFont,
    "code": _renderCodeFont,
    "p": _renderParagraph,
    "i": _renderItalic,
    "b": _renderBold,
    "span": _renderNoop,
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
        _logger.w(
          "Couldn't render HTML tag ($tag), returning it as TextElement.",
        );
      } else {
        _logger.w("Unhandled HTML tag ($tag), returning it as TextElement.");
      }
    }
    // else if (node is dom.Text) {
    //  return TextElement(node.text, children: renderedSubNodes);
    //}

    if (node.text == null) {
      return renderedSubNodes;
    } else {
      return [TextElement(node.text, children: renderedSubNodes)];
    }
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
