import 'package:flutter/material.dart';
import 'package:kaiteki/ui/main/tab.dart';
import 'package:kaiteki_material/kaiteki_material.dart';

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
        destinations: _navigationDestinations,
      );
    }

    return BottomNavigationBar(
      backgroundColor: theme.colorScheme.primary,
      selectedItemColor: theme.colorScheme.onPrimary,
      unselectedItemColor: theme.colorScheme.onPrimary.withOpacity(0.76),
      selectedFontSize: 12,
      showUnselectedLabels: false,
      onTap: onChangeIndex,
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      items: _buildBottomNavigationBarItems(context),
    );
  }

  List<Widget> get _navigationDestinations {
    final navigationDestinations = <NavigationDestination>[];
    for (final tab in tabs) {
      final unreadCount = tab.fetchUnreadCount?.call();
      navigationDestinations.add(
        NavigationDestination(
          icon: Icon(tab.icon).wrapWithLargeBadge(unreadCount),
          selectedIcon: Icon(tab.selectedIcon).wrapWithLargeBadge(unreadCount),
          label: tab.text,
        ),
      );
    }
    return navigationDestinations;
  }

  List<BottomNavigationBarItem> _buildBottomNavigationBarItems(
    BuildContext context,
  ) {
    final theme = Theme.of(context);
    final bottomNavigationBarItems = <BottomNavigationBarItem>[];
    for (final tab in tabs) {
      final unreadCount = tab.fetchUnreadCount?.call();
      bottomNavigationBarItems.add(
        BottomNavigationBarItem(
          backgroundColor: theme.colorScheme.primary,
          icon: Icon(tab.icon).wrapWithLargeBadge(unreadCount),
          activeIcon: Icon(tab.selectedIcon).wrapWithLargeBadge(unreadCount),
          label: tab.text,
        ),
      );
    }
    return bottomNavigationBarItems;
  }
}
