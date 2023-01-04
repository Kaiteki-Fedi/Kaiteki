import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/model/timeline_kind.dart';
import 'package:kaiteki/ui/shared/timeline.dart';
import 'package:kaiteki/utils/extensions.dart';

class TimelinePage extends ConsumerStatefulWidget {
  const TimelinePage({super.key});

  @override
  ConsumerState<TimelinePage> createState() => TimelinePageState();
}

class TimelinePageState extends ConsumerState<TimelinePage> {
  final _timelineKey = GlobalKey<TimelineState>();
  TimelineKind? _kind;

  /// Timeline tabs to show.
  ///
  /// This is intentionally not [TimelineKind.values] because the values might
  /// not be important to the user.
  Set<TimelineKind> get _defaultKinds {
    return const {
      TimelineKind.home,
      TimelineKind.local,
      TimelineKind.bubble,
      TimelineKind.hybrid,
      TimelineKind.federated,
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
    final kinds = _defaultKinds.where(supportedKinds.contains).toSet();
    if (!supportedKinds.contains(_kind)) {
      _kind = supportedKinds.first;
    }

    return DefaultTabController(
      length: kinds.length,
      child: Material(
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
          body: Timeline.kind(
            key: _timelineKey,
            kind: _kind ?? kinds.first,
            maxWidth: 800,
          ),
        ),
      ),
    );
  }

  void refresh() => _timelineKey.currentState!.refresh();

  Widget _buildTab(BuildContext context, TimelineKind kind, bool showLabel) {
    final l10n = context.l10n;

    return Tab(
      icon: Row(
        children: [
          Icon(kind.getIconData()),
          if (showLabel) ...[
            const SizedBox(width: 8),
            Text(kind.getDisplayName(l10n)),
          ],
        ],
      ),
    );
  }

  void _onTabTap(int value, Set<TimelineKind> kinds) {
    final kind = kinds.elementAt(value);
    setState(() => _kind = kind);
  }
}
