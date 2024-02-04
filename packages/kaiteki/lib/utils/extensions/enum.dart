import "package:flutter/material.dart" hide Visibility;
import "package:kaiteki/l10n/localizations.dart";
import "package:kaiteki_core/model.dart";
import "package:mdi/mdi.dart";

extension VisibilityExtensions on PostScope {
  IconData toIconData() {
    return switch (this) {
      PostScope.direct => Icons.email_rounded,
      PostScope.followersOnly => Icons.lock_rounded,
      PostScope.unlisted => Icons.lock_open_rounded,
      PostScope.public => Icons.public_rounded,
      PostScope.circle => Icons.workspaces_rounded,
      PostScope.local => Icons.groups_rounded,
      PostScope.mutuals => Icons.people_rounded
    };
  }

  String toDisplayString(KaitekiLocalizations l10n) {
    return switch (this) {
      PostScope.direct => l10n.visibilityDirect,
      PostScope.followersOnly => l10n.visibilityFollowersOnly,
      PostScope.unlisted => l10n.visibilityUnlisted,
      PostScope.public => l10n.visibilityPublic,
      PostScope.circle => l10n.visibilityCircle,
      PostScope.local => l10n.visibilityLocal,
      PostScope.mutuals => l10n.visibilityMutuals,
    };
  }

  String toDescription(KaitekiLocalizations l10n) {
    return switch (this) {
      PostScope.direct => l10n.visibilityDirectDescription,
      PostScope.followersOnly => l10n.visibilityFollowersOnlyDescription,
      PostScope.unlisted => l10n.visibilityUnlistedDescription,
      PostScope.public => l10n.visibilityPublicDescription,
      PostScope.circle => l10n.visibilityCircleDescription,
      PostScope.local => l10n.visibilityLocalDescription,
      PostScope.mutuals => l10n.visibilityMutualsDescription,
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
