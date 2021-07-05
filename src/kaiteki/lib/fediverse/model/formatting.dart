import 'package:flutter/widgets.dart';
import 'package:mdi/mdi.dart';

enum Formatting {
  plainText,
  markdown,
  html,
  bbCode,
}

extension FormattingExtensions on Formatting {
  IconData toIconData() {
    switch (this) {
      case Formatting.plainText:
        return Mdi.formatTextVariant;
      case Formatting.markdown:
        return Mdi.languageMarkdown;
      case Formatting.html:
        return Mdi.xml;
      case Formatting.bbCode:
        return Mdi.codeBrackets;
    }
  }

  String toHumanString() {
    switch (this) {
      case Formatting.plainText:
        return "Plain text";
      case Formatting.markdown:
        return "Markdown";
      case Formatting.html:
        return "HTML";
      case Formatting.bbCode:
        return "BBCode";
    }
  }
}
