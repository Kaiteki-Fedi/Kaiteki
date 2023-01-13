import "package:flutter/material.dart";
import "package:kaiteki/ui/main/fab_data.dart";
import "package:kaiteki/ui/main/tab_kind.dart";

class MainScreenTab {
  final String text;
  final IconData selectedIcon;
  final IconData icon;
  final FloatingActionButtonData? fab;
  final bool hideFabWhenDesktop;
  final TabKind kind;
  final int? Function()? fetchUnreadCount;

  const MainScreenTab({
    required this.kind,
    required this.selectedIcon,
    required this.text,
    required this.icon,
    this.fab,
    this.hideFabWhenDesktop = false,
    this.fetchUnreadCount,
  });
}
