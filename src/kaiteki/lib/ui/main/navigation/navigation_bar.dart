import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/ui/main/tabs/tab.dart";
import "package:kaiteki_ui/kaiteki_ui.dart";

class MainScreenNavigationBar extends ConsumerWidget {
  final List<MainScreenTabType> tabTypes;
  final int currentIndex;
  final ValueChanged<int>? onChangeIndex;

  const MainScreenNavigationBar({
    super.key,
    required this.tabTypes,
    required this.currentIndex,
    required this.onChangeIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    if (theme.useMaterial3) {
      return NavigationBar(
        onDestinationSelected: onChangeIndex,
        selectedIndex: currentIndex,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: _buildDestinations(context, ref).toList(),
      );
    }

    return BottomNavigationBar(
      selectedFontSize: 12,
      onTap: onChangeIndex,
      currentIndex: currentIndex,
      items: _buildItems(context, ref).toList(),
    );
  }

  Iterable<Widget> _buildDestinations(BuildContext context, WidgetRef ref) {
    return tabTypes.map((type) {
      final unreadCount = type.tab?.fetchUnreadCount.call(ref);
      return NavigationDestination(
        icon: type.icon.wrapWithBadge(unreadCount),
        selectedIcon: type.selectedIcon.wrapWithBadge(unreadCount),
        label: type.getLabel(context.l10n),
      );
    });
  }

  Iterable<BottomNavigationBarItem> _buildItems(
    BuildContext context,
    WidgetRef ref,
  ) {
    return tabTypes.map((type) {
      final unreadCount = type.tab?.fetchUnreadCount.call(ref);
      return BottomNavigationBarItem(
        icon: type.icon.wrapWithBadge(unreadCount),
        activeIcon: type.selectedIcon.wrapWithBadge(unreadCount),
        label: type.getLabel(context.l10n),
      );
    });
  }
}
