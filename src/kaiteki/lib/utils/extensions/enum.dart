import 'package:flutter/material.dart' hide Visibility;
import 'package:kaiteki/fediverse/model/formatting.dart';
import 'package:kaiteki/fediverse/model/timeline_kind.dart';
import 'package:kaiteki/fediverse/model/visibility.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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

  String toDisplayString(AppLocalizations l10n) {
    switch (this) {
      case Visibility.direct:
        return l10n.visibilityDirect;
      case Visibility.followersOnly:
        return l10n.visibilityFollowersOnly;
      case Visibility.unlisted:
        return l10n.visibilityUnlisted;
      case Visibility.public:
        return l10n.visibilityPublic;
    }
  }

  String toDescription(AppLocalizations l10n) {
    switch (this) {
      case Visibility.direct:
        return l10n.visibilityDirectDescription;
      case Visibility.followersOnly:
        return l10n.visibilityFollowersOnlyDescription;
      case Visibility.unlisted:
        return l10n.visibilityUnlistedDescription;
      case Visibility.public:
        return l10n.visibilityPublicDescription;
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
      case TimelineKind.local:
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

  String getDisplayName(AppLocalizations l10n) {
    switch (this) {
      case TimelineKind.federated:
        return l10n.timelineFederated;
      case TimelineKind.home:
        return l10n.timelineHome;
      case TimelineKind.local:
        return l10n.timelineLocal;
      case TimelineKind.directMessages:
        return l10n.timelineDirectMessages;
      case TimelineKind.bookmarks:
        return l10n.timelineBookmarks;
    }
  }

  String getDescription(AppLocalizations l10n) {
    switch (this) {
      case TimelineKind.federated:
        return l10n.timelineFederatedDescription;
      case TimelineKind.home:
        return l10n.timelineHomeDescription;
      case TimelineKind.local:
        return l10n.timelineLocalDescription;
      case TimelineKind.directMessages:
        return l10n.timelineDirectMessagesDescription;
      case TimelineKind.bookmarks:
        return l10n.timelineBookmarksDescription;
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

  String toDisplayString(AppLocalizations l10n) {
    switch (this) {
      case Formatting.plainText:
        return l10n.formattingPlain;
      case Formatting.markdown:
        return "Markdown";
      case Formatting.html:
        return "HTML";
      case Formatting.bbCode:
        return "BBCode";
      case Formatting.misskeyMarkdown:
        return l10n.formattingMfm;
    }
  }
}
