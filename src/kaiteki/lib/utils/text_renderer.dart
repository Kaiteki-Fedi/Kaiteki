import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parseFragment;
import 'package:kaiteki/model/fediverse/emoji.dart';
import 'package:kaiteki/utils/extensions/iterable.dart';
import 'package:kaiteki/utils/logger.dart';
import 'package:kaiteki/utils/text_buffer.dart';
import 'package:kaiteki/utils/text_renderer_theme.dart';
import 'package:url_launcher/url_launcher.dart';

typedef HtmlConstructor = InlineSpan Function(dom.Element element);

class TextRenderer {
  static const String emojiChar = ":";

  final Iterable<Emoji> emojis;
  final TextRendererTheme theme;

  Map<String, HtmlConstructor> htmlConstructors;
  bool hasEmoji;

  TextRenderer({this.emojis, this.theme}) {
    hasEmoji = emojis != null && emojis.length != 0;

    htmlConstructors = {
      "a": renderLink,
    };
  }

  InlineSpan renderFromHtml(String text) {
    if (text == null) {
      return null;
    } else {
      var fragment = parseFragment(text);
      return renderNode(fragment);
    }
  }

  /// This method takes care of parsing emojis and other formatting.
  InlineSpan renderText(String text, {List<InlineSpan> children}) {
    var spans = <InlineSpan>[];
    var buffer = TextBuffer();

    var readingEmoji = false;
    for (var i = 0; i < text.length; i++) {
      var char = text[i];

      if (char == emojiChar && hasEmoji) {
        // If the condition below is true, we should've finished reading the
        // name of an emoji.
        if (!readingEmoji) {
          var emoji = emojis.firstOrDefault((e) => e.name == buffer.text);

          if (emoji == null || !(emoji is CustomEmoji)) {
            // nothing found, so we restore the stolen colon and
            // add a normal text span.
            buffer.prepend(emojiChar);
            spans.add(_plain(buffer));
          } else {
            buffer.clear();

            spans.add(
              WidgetSpan(
                child: Image.network(
                  (emoji as CustomEmoji).url,
                  width: theme.emojiSize,
                  height: theme.emojiSize,
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

    return TextSpan(children: spans..addAll(children));
  }

  InlineSpan renderNode(dom.Node node) {
    InlineSpan resultingSpan;

    var renderedSubNodes = node.nodes
        .map<InlineSpan>((n) => renderNode(n))
        .toList(growable: false);

    if (node is dom.Element) {
      var tag = node.localName.toLowerCase();

      if (htmlConstructors.containsKey(tag)) {
        resultingSpan = htmlConstructors[tag].call(node);
      } else {
        Logger.warning("Unhandled HTML tag ($tag)");
      }
    } else if (node is dom.Text) {
      dom.Text textElement = node;

      resultingSpan = renderText(
        textElement.text,
        children: renderedSubNodes,
      );
    }

    if (resultingSpan == null) {
      resultingSpan = TextSpan(children: renderedSubNodes);
    }

    return resultingSpan;
  }

  InlineSpan renderLink(dom.Element element) {
    var recognizer = new TapGestureRecognizer();

    recognizer.onTap = () {
      // TODO add user mention link support
      // node.classes.contains("mention")

      var linkTarget = element.attributes["href"];
      launch(linkTarget);
    };

    return TextSpan(
      text: element.text,
      recognizer: recognizer,
      style: theme.linkTextStyle,
    );
  }

  TextSpan _plain(TextBuffer buffer) {
    return TextSpan(
      style: theme.textStyle,
      text: buffer.cut(),
    );
  }
}
