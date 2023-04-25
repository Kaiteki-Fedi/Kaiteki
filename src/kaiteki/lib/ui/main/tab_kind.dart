import "package:flutter/material.dart";
import "package:kaiteki/di.dart";

enum TabKind {
  home(Icons.home, Icons.home_outlined),
  notifications(Icons.notifications_none, Icons.notifications_rounded),
  chats(Icons.forum_outlined, Icons.forum),
  bookmarks(Icons.bookmark_border_rounded, Icons.bookmark_rounded);

  final IconData icon;
  final IconData? selectedIcon;

  const TabKind(this.icon, [this.selectedIcon]);

  String getLabel(BuildContext context) {
    final l10n = context.l10n;
    switch (this) {
      case home:
        return l10n.timelineTab;
      case notifications:
        return l10n.notificationsTab;
      case chats:
        return l10n.chatsTab;
      case bookmarks:
        return l10n.bookmarksTab;
    }
  }
}
