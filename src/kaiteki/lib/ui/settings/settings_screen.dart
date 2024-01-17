import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/l10n/localizations.dart";
import "package:kaiteki/ui/settings/locale_list_tile.dart";
import "package:kaiteki/ui/settings/settings_container.dart";
import "package:kaiteki/ui/settings/settings_section.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki_core/utils.dart";

final _items = <(
  String?,
  String Function(KaitekiLocalizations l10n),
  IconData,
)?>[
  ("general", (_) => "General", Icons.pending_rounded),
  (
    "customization",
    (l10n) => l10n.settingsCustomization,
    Icons.palette_rounded
  ),
  ("smart-features", (_) => "Smart features", Icons.auto_awesome_rounded),
  (null, (l10n) => l10n.settingsTabs, Icons.tab_rounded),
  ("wellbeing", (l10n) => l10n.settingsWellbeing, Icons.favorite_rounded),
  (
    "accessibility",
    (l10n) => l10n.settingsAccessibility,
    Icons.accessibility_new_rounded
  ),
  ("privacy-security", (l10n) => "Privacy and security", Icons.shield_rounded),
  null,
  ("tweaks", (l10n) => l10n.settingsTweaks, Icons.tune_rounded),
  ("experiments", (l10n) => l10n.settingsExperiments, Icons.science_rounded),
  ("debug", (l10n) => l10n.settingsDebugMaintenance, Icons.bug_report_rounded),
];

class SettingsScreen extends StatelessWidget {
  final Widget child;

  const SettingsScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    if (WindowWidthSizeClass.fromContext(context) >
        WindowWidthSizeClass.compact) {
      return Scaffold(
        body: Row(
          children: [
            const SizedBox(width: 320, child: _SettingsSidebar()),
            Expanded(child: child),
          ],
        ),
      );
    }

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: GoRouterState.of(context).uri.pathSegments.length > 1
            ? child
            : NestedScrollView(
                headerSliverBuilder: (_, __) => [const _AppBar()],
                body: ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (context, i) {
                    final category = _items[i];

                    if (category == null) {
                      return const Divider();
                    }

                    final routeName = category.$1;
                    return ListTile(
                      leading: Icon(category.$3),
                      title: Text(category.$2(context.l10n)),
                      onTap: routeName == null
                          ? null
                          : () => context.push("/settings/$routeName"),
                    );
                  },
                ),
              ),
      ),
    );
  }
}

class _SettingsSidebar extends StatelessWidget {
  const _SettingsSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final uri = GoRouterState.of(context).uri;
    final l10n = context.l10n;

    final categories = _items.whereNotNull().toList();
    final selectedIndex = uri.pathSegments.elementAtOrNull(1).andThen(
          (route) => categories.indexWhere(
            (e) => e.$1 == route,
          ),
        );
    return NestedScrollView(
      headerSliverBuilder: (_, __) => [const _AppBar()],
      body: NavigationDrawer(
        elevation: 0,
        selectedIndex: selectedIndex == -1 ? null : selectedIndex,
        onDestinationSelected: (i) {
          final category = categories.elementAt(i);
          final routeName = category.$1;
          context.push("/settings/$routeName");
        },
        children: [
          for (final category in _items)
            if (category == null)
              const Padding(
                padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
                child: Divider(),
              )
            else
              NavigationDrawerDestination(
                icon: Icon(category.$3),
                label: Text(category.$2(l10n)),
                enabled: category.$1 != null,
              ),
        ],
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SliverAppBar.large(
      title: Text(l10n.settings),
      floating: true,
      snap: true,
      collapsedHeight: 64,
    );
  }
}
