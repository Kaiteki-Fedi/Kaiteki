import "package:flutter/material.dart";
import "package:kaiteki/di.dart";

enum TabKind {
  home(Icons.home_outlined, Icons.home),
  notifications(Icons.notifications_none, Icons.notifications_rounded),
  chats(Icons.forum_outlined, Icons.forum_rounded),
  bookmarks(Icons.bookmark_border_rounded, Icons.bookmark_rounded),
  explore(Icons.explore_outlined, Icons.explore_rounded),
  directMessages(Icons.mail_outline_rounded, Icons.mail_rounded);

  final IconData icon;
  final IconData? selectedIcon;

  const TabKind(this.icon, [this.selectedIcon]);

  String getLabel(BuildContext context) {
    final l10n = context.l10n;
    return switch (this) {
      home => l10n.homeTab,
      notifications => l10n.notificationsTab,
      chats => l10n.chatsTab,
      bookmarks => l10n.bookmarksTab,
      explore => "Explore",
      directMessages => "Direct Messages",
    };
  }
}
