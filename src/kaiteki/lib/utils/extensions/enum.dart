import "package:flutter/material.dart" hide Visibility;
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:kaiteki/fediverse/model/formatting.dart";
import "package:kaiteki/fediverse/model/timeline_kind.dart";
import "package:kaiteki/fediverse/model/visibility.dart";
import "package:mdi/mdi.dart";

extension VisibilityExtensions on Visibility {
  IconData toIconData() {
    return switch (this) {
      Visibility.direct => Icons.email_rounded,
      Visibility.followersOnly => Icons.lock_rounded,
      Visibility.unlisted => Icons.lock_open_rounded,
      Visibility.public => Icons.public_rounded,
      Visibility.circle => Icons.workspaces_rounded,
      Visibility.local => Icons.groups_rounded,
      Visibility.mutuals => Icons.people_rounded
    };
  }

  String toDisplayString(AppLocalizations l10n) {
    return switch (this) {
      Visibility.direct => l10n.visibilityDirect,
      Visibility.followersOnly => l10n.visibilityFollowersOnly,
      Visibility.unlisted => l10n.visibilityUnlisted,
      Visibility.public => l10n.visibilityPublic,
      Visibility.circle => l10n.visibilityCircle,
      Visibility.local => l10n.visibilityLocal,
      Visibility.mutuals => l10n.visibilityMutuals,
    };
  }

  String toDescription(AppLocalizations l10n) {
    return switch (this) {
      Visibility.direct => l10n.visibilityDirectDescription,
      Visibility.followersOnly => l10n.visibilityFollowersOnlyDescription,
      Visibility.unlisted => l10n.visibilityUnlistedDescription,
      Visibility.public => l10n.visibilityPublicDescription,
      Visibility.circle => l10n.visibilityCircleDescription,
      Visibility.local => l10n.visibilityLocalDescription,
      Visibility.mutuals => l10n.visibilityMutualsDescription,
    };
  }
}

extension FormattingExtensions on Formatting {
  IconData toIconData() {
    return switch (this) {
      Formatting.plainText => Mdi.formatTextVariant,
      Formatting.markdown => Mdi.languageMarkdown,
      Formatting.html => Icons.code_rounded,
      Formatting.bbCode => Icons.data_array_rounded,
      Formatting.misskeyMarkdown => Mdi.languageMarkdown
    };
  }

  String toDisplayString(AppLocalizations l10n) {
    return switch (this) {
      Formatting.plainText => l10n.formattingPlain,
      Formatting.markdown => "Markdown",
      Formatting.html => "HTML",
      Formatting.bbCode => "BBCode",
      Formatting.misskeyMarkdown => l10n.formattingMfm
    };
  }
}

extension TimelindKindExtensions on TimelineKind {
  IconData getIconData() {
    return switch (this) {
      TimelineKind.home => Icons.home_rounded,
      TimelineKind.local => Icons.people_rounded,
      TimelineKind.bubble => Icons.workspaces_rounded,
      TimelineKind.hybrid => Icons.handshake_rounded,
      TimelineKind.federated => Icons.public_rounded,
      TimelineKind.directMessages => Icons.mail_rounded
    };
  }

  String getDisplayName(AppLocalizations l10n) {
    return switch (this) {
      TimelineKind.home => l10n.timelineHome,
      TimelineKind.local => l10n.timelineLocal,
      TimelineKind.bubble => l10n.timelineBubble,
      TimelineKind.hybrid => l10n.timelineHybrid,
      TimelineKind.federated => l10n.timelineFederated,
      TimelineKind.directMessages => l10n.timelineDirectMessages
    };
  }
}
