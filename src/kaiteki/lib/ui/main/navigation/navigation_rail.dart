import 'package:flutter/material.dart';
import 'package:kaiteki/ui/main/compose_fab.dart';
import 'package:kaiteki/ui/main/tab.dart';
import 'package:kaiteki_material/kaiteki_material.dart';

class MainScreenNavigationRail extends StatelessWidget {
  final List<MainScreenTab> tabs;
  final int currentIndex;
  final ValueChanged<int>? onChangeIndex;
  final bool extended;
  final Color? backgroundColor;

  const MainScreenNavigationRail({
    super.key,
    required this.tabs,
    required this.currentIndex,
    this.onChangeIndex,
    required this.extended,
    this.backgroundColor,
  });

  List<NavigationRailDestination> get _destinations {
    final destinations = <NavigationRailDestination>[];
    for (final tab in tabs) {
      final unreadCount = tab.fetchUnreadCount?.call();
      destinations.add(
        NavigationRailDestination(
          icon: Icon(tab.icon).wrapWithLargeBadge(unreadCount),
          selectedIcon: Icon(tab.selectedIcon).wrapWithLargeBadge(unreadCount),
          label: Text(tab.text),
        ),
      );
    }
    return destinations;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return NavigationRail(
      backgroundColor: backgroundColor,
      useIndicator: theme.useMaterial3,
      selectedIndex: currentIndex,
      onDestinationSelected: onChangeIndex,
      extended: extended,
      minWidth: theme.useMaterial3 ? null : 56,
      leading: ComposeFloatingActionButton(
        backgroundColor: theme.colorScheme.tertiaryContainer,
        foregroundColor: theme.colorScheme.onTertiaryContainer,
        type: extended
            ? ComposeFloatingActionButtonType.extended
            : ComposeFloatingActionButtonType.small,
      ),
      destinations: _destinations,
    );
  }
}
