import "package:flutter/material.dart" hide Visibility;
import "package:kaiteki/l10n/localizations.dart";
import "package:kaiteki_core/model.dart";
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

  String toDisplayString(KaitekiLocalizations l10n) {
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

  String toDescription(KaitekiLocalizations l10n) {
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

  String toDisplayString(KaitekiLocalizations l10n) {
    return switch (this) {
      Formatting.plainText => l10n.formattingPlain,
      Formatting.markdown => "Markdown",
      Formatting.html => "HTML",
      Formatting.bbCode => "BBCode",
      Formatting.misskeyMarkdown => l10n.formattingMfm
    };
  }
}

extension TimelindKindExtensions on TimelineType {
  IconData getIconData() {
    return switch (this) {
      TimelineType.following => Icons.home_rounded,
      TimelineType.local => Icons.people_rounded,
      TimelineType.bubble => Icons.workspaces_rounded,
      TimelineType.hybrid => Icons.handshake_rounded,
      TimelineType.federated => Icons.public_rounded,
      TimelineType.directMessages => Icons.mail_rounded,
      TimelineType.recommended => Icons.auto_awesome_rounded,
    };
  }

  String getDisplayName(KaitekiLocalizations l10n) {
    return switch (this) {
      TimelineType.following => l10n.timelineFollowing,
      TimelineType.local => l10n.timelineLocal,
      TimelineType.bubble => l10n.timelineBubble,
      TimelineType.hybrid => l10n.timelineHybrid,
      TimelineType.federated => l10n.timelineFederated,
      TimelineType.directMessages => l10n.timelineDirectMessages,
      // TODO(Craftplacer): Translate
      TimelineType.recommended => "Recommended",
    };
  }
}

extension ThemeModeExtensions on ThemeMode {
  String getDisplayString(KaitekiLocalizations l10n) {
    return switch (this) {
      ThemeMode.system => l10n.themeSystem,
      ThemeMode.light => l10n.themeLight,
      ThemeMode.dark => l10n.themeDark,
    };
  }
}
