import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/fediverse/services/timeline.dart";
import "package:kaiteki/preferences/theme_preferences.dart";
import "package:kaiteki/ui/shared/posts/post_widget.dart";
import "package:kaiteki/ui/shared/timeline/source.dart";
import "package:kaiteki/ui/shared/timeline/widget.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/social.dart";

/// Timeline tabs to show.
///
/// This is intentionally not [TimelineType.values] because the values might
/// not be important to the user.
Set<TimelineType> get _defaultKinds {
  return const {
    TimelineType.following,
    TimelineType.local,
    TimelineType.bubble,
    TimelineType.hybrid,
    TimelineType.federated,
  };
}

final currentTimelineProvider = StateProvider(
  (ref) => ref.read(_tabsProvider).first,
  dependencies: [_tabsProvider],
);

final _tabsProvider = Provider(
  (ref) {
    return ref.watch(
      adapterProvider.select((adapter) {
        final supportedKinds = adapter.capabilities.supportedTimelines;
        return _defaultKinds.where(supportedKinds.contains);
      }),
    );
  },
  dependencies: [adapterProvider],
);

class TimelinePage extends ConsumerStatefulWidget {
  final TimelineType? initialTimeline;

  const TimelinePage({super.key, this.initialTimeline});

  @override
  ConsumerState<TimelinePage> createState() => TimelinePageState();
}

class TimelinePageState extends ConsumerState<TimelinePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  TimelineType get timeline {
    return ref.read(_tabsProvider).elementAt(_tabController.index);
  }

  @override
  void initState() {
    super.initState();

    final tabs = ref.read(_tabsProvider);
    final currentTimeline = ref.read(currentTimelineProvider);
    _tabController = TabController(
      vsync: this,
      length: tabs.length,
      initialIndex: tabs.toList().indexOf(currentTimeline),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tab = ref.watch(currentTimelineProvider);
    final tabs = ref.watch(_tabsProvider);
    if (!tabs.contains(tab)) {
      ref.read(currentTimelineProvider.notifier).state = tabs.first;
    }

    final showTabBar = tabs.length >= 2;
    final showTabLabel = tabs.length <= 3;
    return NestedScrollView(
      floatHeaderSlivers: true,
      dragStartBehavior: DragStartBehavior.down,
      headerSliverBuilder: (context, _) {
        return [
          if (showTabBar)
            SliverToBoxAdapter(
              child: Column(
                children: [
                  TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    onTap: (i) => _onTabTap(i, tabs),
                    tabs: [
                      for (final type in tabs)
                        _buildTab(context, type, showTabLabel),
                    ],
                  ),
                  const Divider(height: 1),
                ],
              ),
            ),
        ];
      },
      body: TabBarView(
        controller: _tabController,
        children: [for (final type in tabs) buildPage(type)],
      ),
    );
  }

  Widget buildPage(TimelineType type) {
    final timelineSource = StandardTimelineSource(type);
    return RefreshIndicator(
      onRefresh: () async {
        final key = ref.read(currentAccountProvider)!.key;
        final provider = TimelineServiceProvider(key, timelineSource);
        await ref.read(provider.notifier).refresh();
      },
      child: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: 800,
          child: Timeline(
            timelineSource,
            postLayout: ref.watch(useWidePostLayout).value
                ? PostWidgetLayout.wide
                : PostWidgetLayout.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildTab(BuildContext context, TimelineType kind, bool showLabel) {
    final l10n = context.l10n;

    return Semantics(
      label: kind.getDisplayName(l10n),
      child: Tab(
        icon: ExcludeSemantics(
          child: Row(
            children: [
              Icon(kind.getIconData()),
              if (showLabel) ...[
                const SizedBox(width: 8),
                Text(kind.getDisplayName(l10n)),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _onTabTap(int value, Iterable<TimelineType> kinds) {
    ref.read(currentTimelineProvider.notifier).state = kinds.elementAt(value);
  }
}
