import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/dom.dart';
import 'package:html/parser.dart' show parseFragment;
import 'package:kaiteki/model/fediverse/emoji.dart';
import 'package:kaiteki/utils/logger.dart';
import 'package:kaiteki/utils/text_buffer.dart';
import 'package:url_launcher/url_launcher.dart';

class TextRenderer {
  Iterable<Emoji> emojis;

  TextStyle textStyle;
  TextStyle linkTextStyle;

  static const String emojiChar = ":";
  static const String linkTag = "a";

  bool get _supportEmoji => emojis != null && emojis.length != 0;
  
  TextRenderer({this.emojis, this.textStyle, this.linkTextStyle});

  InlineSpan render(String text) {
    if (text == null)
      return null;

    return renderNode(parseFragment(text));
  }

  InlineSpan renderSpecial(String text, {List<InlineSpan> children}) {
    var spans = <InlineSpan>[];
    var buffer = TextBuffer();

    var readingEmoji = false;
    for (var i = 0; i < text.length; i++) {
      var char = text[i];

      switch (char) {
        case emojiChar: {
          if (!_supportEmoji)
            continue;

          if (readingEmoji) {
            var emojiName = buffer.text;
            var emojiFound = emojis.any((e) => e.name == emojiName);

            void restoreEmoji() {
              // nothing found, so we restore the stolen colon and add a normal text span.
              buffer.prepend(emojiChar);
              spans.add(plain(buffer));
              readingEmoji = true;
            }

            if (emojiFound) {
              var emoji = emojis.firstWhere((e) => e.name == emojiName);

              // TODO: refactor
              if (emoji is CustomEmoji) {
                buffer.clear();

                // FIXME: fix it or I will make you not-cute >:(
                var emojiSpan = WidgetSpan(
                  child: Image.network(
                    emoji.url,
                    width: 32,
                    height: 32,
                  ),
                );

                spans.add(emojiSpan);

                readingEmoji = false;
              } else {
                restoreEmoji();
              }
            } else {
              restoreEmoji();
            }
          } else {
            spans.add(plain(buffer));
            readingEmoji = true;
          }

          break;
        }
        default: {
          buffer.append(char);
          break;
        }
      }
    }

    if (buffer.text.isNotEmpty)
      spans.add(plain(buffer));

    return TextSpan(children: spans..addAll(children));
  }

  InlineSpan renderNode(Node node) {
    InlineSpan resultingSpan;

    var renderedSubNodes = node.nodes
      .map<InlineSpan>((n) => renderNode(n))
      .toList(growable: false);

    if (node is dom.Element) {
      if (node.localName == linkTag) {
        var recognizer = new TapGestureRecognizer();
        recognizer.onTap = () {
          // TODO: add user mention link support
          // node.classes.contains("mention")

          var linkTarget = node.attributes["href"];
          launch(linkTarget);
        };

        resultingSpan = TextSpan(
          text: node.text,
          recognizer: recognizer,
          style: textStyle.copyWith(
            decoration: TextDecoration.underline,
            color: Colors.blue
          )
        );
      } else {
        Logger.warning("Unhandled HTML tag: ${node.localName}");
      }
    } else if (node is dom.Text) {
      dom.Text textElement = node;
      resultingSpan = renderSpecial(
        textElement.text,
        children: renderedSubNodes,
      );
    }

    if (resultingSpan == null) {
      resultingSpan = TextSpan(
        children: renderedSubNodes
      );
    }

    return resultingSpan;
  }

  TextSpan plain(TextBuffer buffer) => TextSpan(
    style: textStyle,
    text: buffer.cut()
  );
}



