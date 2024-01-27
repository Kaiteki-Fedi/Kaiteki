import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/app_preferences.dart";
import "package:kaiteki/ui/main/tabs/tab.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki/ui/shared/icon_landing_widget.dart";
import "package:kaiteki/utils/extensions/enum.dart";
import "package:kaiteki_core/kaiteki_core.dart";

class TabsSettingsScreen extends StatefulWidget {
  const TabsSettingsScreen({super.key});

  @override
  State<TabsSettingsScreen> createState() => _TabsSettingsScreenState();
}

class _TabsSettingsScreenState extends State<TabsSettingsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  // ignore: unused_field
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this)
      ..addListener(() {
        setState(() {
          _currentPage = _tabController.index;
        });
      });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isCompact = WindowWidthSizeClass.fromContext(context) <=
        WindowWidthSizeClass.compact;

    // final addTimelineFAB = FloatingActionButton.extended(
    //   onPressed: () {
    //     showDialog(
    //       context: context,
    //       builder: (_) => const AddTimelineDialog(),
    //     );
    //   },
    //   icon: const Icon(Icons.add_rounded),
    //   label: const Text("Add timeline"),
    // );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tabs"),
        bottom: TabBar(
          controller: _tabController,
          tabAlignment: isCompact ? null : TabAlignment.center,
          isScrollable: true,
          tabs: const [
            Tab(text: "App destinations"),
            Tab(text: "Timelines"),
          ],
        ),
      ),
      // floatingActionButton: _currentPage == 1 ? addTimelineFAB : null,
      body: TabBarView(
        controller: _tabController,
        children: const [
          _AppDestinationsPage(),
          Center(
            child: IconLandingWidget(
              icon: Icon(Icons.assignment_late_rounded),
              text: Text("Not implemented yet"),
            ),
          )
        ],
      ),
    );
  }
}

class _TimelinesPage extends ConsumerWidget {
  const _TimelinesPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final supportedTimelines = ref.watch(
      adapterProvider.select((e) => e.capabilities.supportedTimelines),
    );

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: ReorderableListView(
          buildDefaultDragHandles: true,
          children: [
            for (final timeline in TimelineType.values)
              ListTile(
                leading: Icon(timeline.getIconData()),
                key: ValueKey(timeline.index),
                title: Text(timeline.getDisplayName(context.l10n)),
                enabled: supportedTimelines.contains(timeline),
                subtitle: supportedTimelines.contains(timeline)
                    ? null
                    : const Text("Not supported by this instance"),
              ),
          ],
          onReorder: (oldIndex, newIndex) {},
        ),
      ),
    );
  }
}

class _AppDestinationsPage extends ConsumerWidget {
  const _AppDestinationsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(mainScreenTabOrder).value;
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: ReorderableListView(
          buildDefaultDragHandles: true,
          children: [
            for (final tab in order)
              _DestinationSwitchListTile(
                tab,
                key: ValueKey(tab.index),
              ),
          ],
          onReorder: (oldIndex, newIndex) {
            final oldList = ref.read(mainScreenTabOrder).value;
            ref.read(mainScreenTabOrder).value = oldList.toList()
              ..removeAt(oldIndex)
              ..insert(newIndex, oldList[oldIndex]);
          },
        ),
      ),
    );
  }
}

class _DestinationSwitchListTile extends ConsumerWidget {
  const _DestinationSwitchListTile(
    this.tab, {
    super.key,
  });

  final MainScreenTabType tab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final disabledTabs = ref.watch(disabledMainScreenTabs).value;
    final enabledCount = MainScreenTabType.values.length - disabledTabs.length;
    final isDisabled = disabledTabs.contains(tab);
    return SwitchListTile(
      contentPadding: const EdgeInsets.only(left: 16.0, right: 48.0),
      secondary: tab.selectedIcon,
      key: ValueKey(tab.index),
      title: Text(tab.getLabel(l10n)),
      subtitle: _isSupported(ref)
          ? null
          : const Text("Not supported by this instance"),
      value: !isDisabled,
      onChanged: enabledCount <= 1 && !isDisabled
          ? null
          : (value) {
              final newSet = disabledTabs.toSet();

              if (value) {
                newSet.remove(tab);
              } else {
                newSet.add(tab);
              }

              ref.read(disabledMainScreenTabs).value = newSet;
            },
    );
  }

  bool _isSupported(WidgetRef ref) {
    final adapter = ref.watch(adapterProvider);
    return switch (tab) {
      MainScreenTabType.home => true,
      MainScreenTabType.notifications => adapter is NotificationSupport,
      MainScreenTabType.bookmarks => adapter is BookmarkSupport,
      MainScreenTabType.chats => adapter is ChatSupport,
      MainScreenTabType.explore => adapter is ExploreSupport
    };
  }
}
