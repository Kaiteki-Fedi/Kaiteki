import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/adapter.dart';
import 'package:kaiteki/fediverse/model/timeline_kind.dart';
import 'package:kaiteki/ui/rounded_underline_tab_indicator.dart';
import 'package:kaiteki/ui/widgets/timeline.dart';

class TimelinePage extends ConsumerStatefulWidget {
  const TimelinePage({super.key});

  @override
  ConsumerState<TimelinePage> createState() => TimelinePageState();
}

class TimelinePageState extends ConsumerState<TimelinePage> {
  final _timelineKey = GlobalKey<TimelineState>();
  TimelineKind? _kind;

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
    final supported =
        ref.watch(adapterProvider).capabilities.supportedTimelines;
    final kinds = _defaultKinds.where(supported.contains).toSet();

    // ignore: avoid_types_on_closure_parameters, Dart is unable to infer type
    ref.listen(adapterProvider, (previous, BackendAdapter next) {
      if (!next.capabilities.supportedTimelines.contains(_kind)) {
        _kind = next.capabilities.supportedTimelines.first;
      }
    });

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
    final l10n = context.getL10n();

    final Widget label;
    final Widget icon;

    switch (kind) {
      case TimelineKind.home:
        icon = const Icon(Icons.home_rounded);
        label = Text(l10n.timelineHome);
        break;

      case TimelineKind.local:
        icon = const Icon(Icons.people_rounded);
        label = Text(l10n.timelineLocal);
        break;

      case TimelineKind.bubble:
        icon = const Icon(Icons.workspaces_rounded);
        label = Text(l10n.timelineBubble);
        break;

      case TimelineKind.hybrid:
        icon = const Icon(Icons.handshake_rounded);
        label = Text(l10n.timelineHybrid);
        break;

      case TimelineKind.federated:
        icon = const Icon(Icons.public_rounded);
        label = Text(l10n.timelineFederated);
        break;

      case TimelineKind.directMessages:
        icon = const Icon(Icons.mail_rounded);
        label = Text(l10n.timelineDirectMessages);
        break;
    }

    return Tab(
      icon: Row(
        children: [
          icon,
          if (showLabel) ...[
            const SizedBox(width: 8),
            label,
          ],
        ],
      ),
    );
  }

  void _onTabTap(int value, Set<TimelineKind> kinds) {
    final kind = kinds.elementAt(value);
    setState(() {
      _kind = kind;
      refresh();
    });
  }
}
