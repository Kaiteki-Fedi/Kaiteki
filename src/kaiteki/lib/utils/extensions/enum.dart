import "package:flutter/material.dart" hide Visibility;
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:kaiteki/fediverse/model/formatting.dart";
import "package:kaiteki/fediverse/model/timeline_kind.dart";
import "package:kaiteki/fediverse/model/visibility.dart";
import "package:mdi/mdi.dart";

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

      case Visibility.circle:
        return Icons.workspaces_rounded;
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
      case Visibility.circle:
        return l10n.visibilityCircle;
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
      case Visibility.circle:
        return l10n.visibilityCircleDescription;
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

extension TimelindKindExtensions on TimelineKind {
  IconData getIconData() {
    switch (this) {
      case TimelineKind.home:
        return Icons.home_rounded;

      case TimelineKind.local:
        return Icons.people_rounded;

      case TimelineKind.bubble:
        return Icons.workspaces_rounded;

      case TimelineKind.hybrid:
        return Icons.handshake_rounded;

      case TimelineKind.federated:
        return Icons.public_rounded;

      case TimelineKind.directMessages:
        return Icons.mail_rounded;
    }
  }

  String getDisplayName(AppLocalizations l10n) {
    switch (this) {
      case TimelineKind.home:
        return l10n.timelineHome;

      case TimelineKind.local:
        return l10n.timelineLocal;

      case TimelineKind.bubble:
        return l10n.timelineBubble;

      case TimelineKind.hybrid:
        return l10n.timelineHybrid;

      case TimelineKind.federated:
        return l10n.timelineFederated;

      case TimelineKind.directMessages:
        return l10n.timelineDirectMessages;
    }
  }
}
