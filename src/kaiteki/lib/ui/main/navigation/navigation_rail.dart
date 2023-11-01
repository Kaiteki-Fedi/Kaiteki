import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/ui/main/tabs/tab.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_ui/kaiteki_ui.dart";

class MainScreenNavigationRail extends ConsumerWidget {
  final List<MainScreenTabType> tabTypes;
  final int currentIndex;
  final ValueChanged<int>? onChangeIndex;
  final Color? backgroundColor;

  const MainScreenNavigationRail({
    super.key,
    required this.tabTypes,
    required this.currentIndex,
    this.onChangeIndex,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return NavigationRail(
      backgroundColor: backgroundColor,
      useIndicator: theme.useMaterial3,
      selectedIndex: currentIndex,
      onDestinationSelected: onChangeIndex,
      minWidth: theme.useMaterial3 ? null : 56,
      labelType: NavigationRailLabelType.all,
      leading: FloatingActionButton(
        backgroundColor: theme.colorScheme.tertiaryContainer,
        foregroundColor: theme.colorScheme.onTertiaryContainer,
        elevation: 0,
        onPressed: () => context.pushNamed(
          "compose",
          pathParameters: ref.accountRouterParams,
        ),
        heroTag: const ValueKey("navigation rail"),
        child: const Icon(Icons.edit_rounded),
      ),
      destinations: _buildDestinations(context, ref).toList(),
    );
  }

  Iterable<NavigationRailDestination> _buildDestinations(
    BuildContext context,
    WidgetRef ref,
  ) {
    return tabTypes.map((type) {
      final unreadCount = type.tab?.fetchUnreadCount.call(ref) ?? 0;

      return NavigationRailDestination(
        icon: type.icon.wrapWithBadge(unreadCount),
        selectedIcon: type.selectedIcon.wrapWithBadge(unreadCount),
        label: Text(type.getLabel(context.l10n)),
      );
    });
  }
}
