import "package:flutter/material.dart";
import "package:kaiteki/ui/main/tab.dart";
import "package:kaiteki_material/kaiteki_material.dart";

class MainScreenNavigationBar extends StatelessWidget {
  final List<MainScreenTab> tabs;
  final int currentIndex;
  final ValueChanged<int>? onChangeIndex;

  const MainScreenNavigationBar({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onChangeIndex,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (theme.useMaterial3) {
      return NavigationBar(
        onDestinationSelected: onChangeIndex,
        selectedIndex: currentIndex,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: _buildNavigationDestinations(context),
      );
    }

    return BottomNavigationBar(
      selectedFontSize: 12,
      onTap: onChangeIndex,
      currentIndex: currentIndex,
      items: _buildBottomNavigationBarItems(context),
    );
  }

  List<Widget> _buildNavigationDestinations(BuildContext context) {
    final navigationDestinations = <NavigationDestination>[];
    for (final tab in tabs) {
      final unreadCount = tab.fetchUnreadCount?.call();
      navigationDestinations.add(
        NavigationDestination(
          icon: Icon(tab.kind.icon).wrapWithLargeBadge(unreadCount),
          selectedIcon:
              Icon(tab.kind.selectedIcon).wrapWithLargeBadge(unreadCount),
          label: tab.kind.getLabel(context),
        ),
      );
    }
    return navigationDestinations;
  }

  List<BottomNavigationBarItem> _buildBottomNavigationBarItems(
    BuildContext context,
  ) {
    final bottomNavigationBarItems = <BottomNavigationBarItem>[];
    for (final tab in tabs) {
      final unreadCount = tab.fetchUnreadCount?.call();
      bottomNavigationBarItems.add(
        BottomNavigationBarItem(
          icon: Icon(tab.kind.icon).wrapWithLargeBadge(unreadCount),
          activeIcon:
              Icon(tab.kind.selectedIcon).wrapWithLargeBadge(unreadCount),
          label: tab.kind.getLabel(context),
        ),
      );
    }
    return bottomNavigationBarItems;
  }
}
