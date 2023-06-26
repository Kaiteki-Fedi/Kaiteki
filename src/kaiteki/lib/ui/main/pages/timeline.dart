import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/theme_preferences.dart";
import "package:kaiteki/ui/shared/posts/post_widget.dart";
import "package:kaiteki/ui/shared/timeline.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/social.dart";

class TimelinePage extends ConsumerStatefulWidget {
  final TimelineType? initialTimeline;

  const TimelinePage({super.key, this.initialTimeline});

  @override
  ConsumerState<TimelinePage> createState() => TimelinePageState();
}

class TimelinePageState extends ConsumerState<TimelinePage> {
  final _timelineKey = GlobalKey<TimelineState>();
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final adapter = ref.watch(adapterProvider);
    final supportedKinds = adapter.capabilities.supportedTimelines;
    final kinds = _defaultKinds.where(supportedKinds.contains);
    if (!supportedKinds.contains(_kind)) {
      _kind = supportedKinds.first;
    }

    final initialIndex = kinds.toList().indexOf(_kind!);
    return DefaultTabController(
      length: kinds.length,
      initialIndex: initialIndex,
      child: NestedScrollView(
        floatHeaderSlivers: true,
        dragStartBehavior: DragStartBehavior.down,
        headerSliverBuilder: (context, _) => [
          if (kinds.length >= 2)
            SliverToBoxAdapter(
              child: Column(
                children: [
                  TabBar(
                    isScrollable: true,
                    indicatorSize: TabBarIndicatorSize.label,
                    onTap: (i) => _onTabTap(i, kinds),
                    tabs: [
                      for (final kind in kinds)
                        _buildTab(context, kind, kinds.length <= 3),
                    ],
                  ),
                  const Divider(height: 1),
                ],
              ),
            ),
        ],
        body: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: 800,
            child: Timeline.kind(
              key: _timelineKey,
              kind: _kind ?? kinds.first,
              postLayout: ref.watch(useWidePostLayout).value
                  ? PostWidgetLayout.wide
                  : PostWidgetLayout.normal,
            ),
          ),
        ),
      ),
    );
  }

  void refresh() => _timelineKey.currentState!.refresh();

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
