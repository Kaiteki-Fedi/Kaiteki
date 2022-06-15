import 'package:flutter/material.dart' hide Visibility;
import 'package:kaiteki/fediverse/model/formatting.dart';
import 'package:kaiteki/fediverse/model/visibility.dart';
import 'package:mdi/mdi.dart';

extension VisibilityExtensions on Visibility {
  IconData toIconData() {
    switch (this) {
      case Visibility.direct:
        return Icons.email_rounded;

      case Visibility.followersOnly:
        return Icons.lock_rounded;

      case Visibility.unlisted:
        return Icons.lock_open_rounded;

      case Visibility.public:
        return Icons.public_rounded;
    }
  }

  String toDisplayString() {
    switch (this) {
      case Visibility.direct:
        return 'Direct';
      case Visibility.followersOnly:
        return 'Followers only';
      case Visibility.unlisted:
        return 'Unlisted';
      case Visibility.public:
        return 'Public';
    }
  }
}

extension FormattingExtensions on Formatting {
  IconData toIconData() {
    switch (this) {
      case Formatting.plainText:
        return Mdi.formatTextVariant;
      case Formatting.markdown:
        return Mdi.languageMarkdown;
      case Formatting.html:
        return Icons.code_rounded;
      case Formatting.bbCode:
        return Icons.data_array_rounded;
    }
  }

  String toDisplayString() {
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
