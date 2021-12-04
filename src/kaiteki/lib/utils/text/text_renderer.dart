import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parseFragment;
import 'package:kaiteki/fediverse/model/emoji.dart';
import 'package:kaiteki/logger.dart';
import 'package:kaiteki/ui/widgets/emoji/emoji_widget.dart';
import 'package:kaiteki/utils/extensions/iterable.dart';
import 'package:kaiteki/utils/text/text_buffer.dart';
import 'package:kaiteki/utils/text/text_renderer_theme.dart';
import 'package:url_launcher/url_launcher.dart';

typedef HtmlConstructor = InlineSpan Function(
  dom.Element element,
  List<InlineSpan> subElements,
);

class TextRenderer {
  static const String emojiChar = ":";
  static final _logger = getLogger("TextRenderer");

  final Iterable<Emoji>? emojis;
  final TextRendererTheme theme;

  late final Map<String, HtmlConstructor> htmlConstructors;
  late final bool hasEmoji;

  TextRenderer({this.emojis, required this.theme}) {
    hasEmoji = emojis != null && emojis!.isNotEmpty;

    htmlConstructors = {
      "a": _renderLink,
      "br": _renderBreakLine,
      "pre": _renderCodeFont,
      "code": _renderCodeFont,
      "p": _renderParagraph,
      "i": _renderItalic,
      "b": _renderBold,
    };
  }

  InlineSpan renderFromHtml(BuildContext context, String text) {
    final fragment = parseFragment(text);
    return renderNode(fragment);
  }

  /// This method takes care of parsing emojis and other formatting.
  InlineSpan renderText(String text, {List<InlineSpan>? children}) {
    var spans = <InlineSpan>[];
    var buffer = TextBuffer();

    var readingEmoji = false;
    for (var i = 0; i < text.length; i++) {
      var char = text[i];

      if (char == emojiChar && hasEmoji) {
        // If the condition below is true, we should've finished reading the
        // name of an emoji.
        if (readingEmoji) {
          var emoji = emojis!.firstOrDefault((e) => e.name == buffer.text);

          if (emoji == null || emoji is! CustomEmoji) {
            // nothing found, so we restore the stolen colon and
            // add a normal text span.
            buffer.prepend(emojiChar);
            spans.add(_plain(buffer));
          } else {
            buffer.clear();

            spans.add(
              WidgetSpan(
                child: EmojiWidget(
                  emoji: emoji,
                  size: theme.emojiSize,
                ),
              ),
            );
          }

          readingEmoji = false;
        } else {
          spans.add(_plain(buffer));
          readingEmoji = true;
        }
      } else {
        buffer.append(char);
      }
    }

    if (buffer.text.isNotEmpty) {
      spans.add(_plain(buffer));
    }

    return TextSpan(children: spans..addAll(children ?? []));
  }

  InlineSpan renderNode(dom.Node node) {
    InlineSpan? resultingSpan;

    final renderedSubNodes =
        node.nodes.map<InlineSpan>(renderNode).toList(growable: false);

    if (node is dom.Element) {
      final tag = node.localName!.toLowerCase();

      if (htmlConstructors.containsKey(tag)) {
        final htmlConstructor = htmlConstructors[tag]!;

        resultingSpan = htmlConstructor.call(
          node,
          renderedSubNodes,
        );
      } else {
        _logger.w("Unhandled HTML tag ($tag)");
      }
    } else if (node is dom.Text) {
      dom.Text textElement = node;

      resultingSpan = renderText(
        textElement.text,
        children: renderedSubNodes,
      );
    }

    resultingSpan ??= TextSpan(children: renderedSubNodes);

    return resultingSpan;
  }

  InlineSpan _renderLink(
    dom.Element element,
    List<InlineSpan> subElements,
  ) {
    var recognizer = TapGestureRecognizer()
      ..onTap = () {
        var linkTarget = element.attributes["href"];
        launch(linkTarget!);
      };

    return TextSpan(
      text: element.text,
      recognizer: recognizer,
      style: theme.linkTextStyle,
    );
  }

  InlineSpan _renderBreakLine(
    dom.Element element,
    List<InlineSpan> subElements,
  ) {
    return const TextSpan(text: "\n");
  }

  InlineSpan _renderCodeFont(
    dom.Element element,
    List<InlineSpan> subElements,
  ) {
    return TextSpan(
      text: element.text,
      style: GoogleFonts.robotoMono(),
    );
  }

  InlineSpan _renderItalic(
    dom.Element element,
    List<InlineSpan> subElements,
  ) {
    return TextSpan(
      text: element.text,
      style: const TextStyle(fontStyle: FontStyle.italic),
    );
  }

  InlineSpan _renderBold(
    dom.Element element,
    List<InlineSpan> subElements,
  ) {
    return TextSpan(
      text: element.text,
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }

  InlineSpan _renderParagraph(
    dom.Element element,
    List<InlineSpan> subElements,
  ) {
    var text = "";

    if (element.previousElementSibling?.localName == "p") {
      text = "\n\n" + text;
    }

    return TextSpan(text: text, children: subElements);
  }

  TextSpan _plain(TextBuffer buffer) {
    return TextSpan(text: buffer.cut());
  }
}
