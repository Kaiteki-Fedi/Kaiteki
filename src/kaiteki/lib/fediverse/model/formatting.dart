import 'package:flutter/widgets.dart';
import 'package:mdi/mdi.dart';

enum Formatting {
  PlainText,
  Markdown,
  HTML,
  BBCode,
}

extension FormattingExtensions on Formatting {
  IconData toIconData() {
    switch (this) {
      case Formatting.PlainText: return Mdi.formatTextVariant;
      case Formatting.Markdown: return Mdi.languageMarkdown;
      case Formatting.HTML: return Mdi.xml;
      case Formatting.BBCode: return Mdi.codeBrackets;
    }
  }

  String toHumanString() {
    switch (this) {
      case Formatting.PlainText: return "Plain text";
      case Formatting.Markdown: return "Markdown";
      case Formatting.HTML: return "HTML";
      case Formatting.BBCode: return "BBCode";
    }
  }
}
