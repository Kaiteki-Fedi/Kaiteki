import 'package:flutter/material.dart' hide Visibility;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
