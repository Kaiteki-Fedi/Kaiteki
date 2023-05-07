import "package:flutter/material.dart";
import "package:kaiteki/di.dart";

enum TabKind {
  home(Icons.home_outlined, Icons.home),
  notifications(Icons.notifications_none, Icons.notifications_rounded),
  chats(Icons.forum_outlined, Icons.forum),
  bookmarks(Icons.bookmark_border_rounded, Icons.bookmark_rounded);

  final IconData icon;
  final IconData? selectedIcon;

  const TabKind(this.icon, [this.selectedIcon]);

  String getLabel(BuildContext context) {
    final l10n = context.l10n;
    return switch (this) {
      home => l10n.timelineTab,
      notifications => l10n.notificationsTab,
      chats => l10n.chatsTab,
      bookmarks => l10n.bookmarksTab
    };
  }
}
