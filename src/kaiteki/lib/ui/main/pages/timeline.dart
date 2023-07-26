import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/theme_preferences.dart";
import "package:kaiteki/ui/shared/posts/post_widget.dart";
import "package:kaiteki/ui/shared/timeline/source.dart";
import "package:kaiteki/ui/shared/timeline/widget.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/social.dart";

class TimelinePage extends ConsumerStatefulWidget {
  final TimelineType? initialTimeline;

  const TimelinePage({super.key, this.initialTimeline});

  @override
  ConsumerState<TimelinePage> createState() => TimelinePageState();
}

class TimelinePageState extends ConsumerState<TimelinePage> {
  late TimelineType? _kind = widget.initialTimeline;

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

  @override
  Widget build(BuildContext context) {
    final adapter = ref.watch(adapterProvider);
    final supportedKinds = adapter.capabilities.supportedTimelines;
    final types = _defaultKinds.where(supportedKinds.contains);
    if (!supportedKinds.contains(_kind)) {
      _kind = supportedKinds.first;
    }

    final initialIndex = types.toList().indexOf(_kind!);
    final showTabBar = types.length >= 2;
    final showTabLabel = types.length <= 3;
    return DefaultTabController(
      length: types.length,
      initialIndex: initialIndex,
      child: NestedScrollView(
        floatHeaderSlivers: true,
        dragStartBehavior: DragStartBehavior.down,
        headerSliverBuilder: (context, _) {
          return [
            if (showTabBar)
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    TabBar(
                      isScrollable: true,
                      onTap: (i) => _onTabTap(i, types),
                      tabs: [
                        for (final type in types)
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
          children: [
            for (final type in types)
              Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: 800,
                  child: Timeline(
                    StandardTimelineSource(type),
                    postLayout: ref.watch(useWidePostLayout).value
                        ? PostWidgetLayout.wide
                        : PostWidgetLayout.normal,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  void refresh() {
    // _timelineKey.currentState!.refresh();
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
    final kind = kinds.elementAt(value);
    setState(() => _kind = kind);
  }
}
