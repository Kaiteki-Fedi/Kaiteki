import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/model/timeline_kind.dart';
import 'package:kaiteki/ui/widgets/timeline.dart';

class TimelinePage extends ConsumerStatefulWidget {
  final TimelineKind kind;

  const TimelinePage(this.kind, {super.key});

  @override
  ConsumerState<TimelinePage> createState() => TimelinePageState();
}

class TimelinePageState extends ConsumerState<TimelinePage> {
  final _timelineKey = GlobalKey<TimelineState>();

  @override
  void didUpdateWidget(covariant TimelinePage oldWidget) {
    if (widget.kind != oldWidget.kind) refresh();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Timeline.kind(
      key: _timelineKey,
      kind: widget.kind,
      maxWidth: 800,
    );
  }

  void refresh() => _timelineKey.currentState!.refresh();
}
