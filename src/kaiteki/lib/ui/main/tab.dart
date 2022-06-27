import 'package:flutter/material.dart';
import 'package:kaiteki/ui/main/fab_data.dart';

class MainScreenTab {
  final String text;
  final IconData selectedIcon;
  final IconData icon;
  final FloatingActionButtonData? fab;
  final bool hideFabWhenDesktop;
  final int index;

  const MainScreenTab({
    required this.index,
    required this.selectedIcon,
    required this.text,
    required this.icon,
    this.fab,
    this.hideFabWhenDesktop = false,
  });
}
