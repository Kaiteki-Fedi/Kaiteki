import 'package:flutter/material.dart' hide Visibility;
import 'package:kaiteki/fediverse/model/formatting.dart';
import 'package:kaiteki/fediverse/model/timeline_kind.dart';
import 'package:kaiteki/fediverse/model/visibility.dart';
import 'package:mdi/mdi.dart';
import 'package:tuple/tuple.dart';

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

extension TimelineKindExtensions on TimelineKind {
  Tuple2<IconData, IconData> get icon {
    switch (this) {
      case TimelineKind.federated:
        return const Tuple2(Icons.public_rounded, Icons.public_rounded);
      case TimelineKind.home:
        return const Tuple2(Icons.home_outlined, Icons.home_rounded);
      case TimelineKind.public:
        return const Tuple2(Icons.people_outline_rounded, Icons.people_rounded);
      case TimelineKind.directMessages:
        return const Tuple2(Icons.mail_outline_rounded, Icons.mail_rounded);
      case TimelineKind.bookmarks:
        return const Tuple2(
          Icons.bookmark_border_rounded,
          Icons.bookmark_rounded,
        );
    }
  }

  String get displayName {
    switch (this) {
      case TimelineKind.federated:
        return "Federated";
      case TimelineKind.home:
        return "Home";
      case TimelineKind.public:
        return "Public";
      case TimelineKind.directMessages:
        return "Direct Messages";
      case TimelineKind.bookmarks:
        return "Bookmarks";
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
      case Formatting.misskeyMarkdown:
        return Mdi.languageMarkdown;
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
      case Formatting.misskeyMarkdown:
        return "Misskey-flavored Markdown (MFM)";
    }
  }
}
