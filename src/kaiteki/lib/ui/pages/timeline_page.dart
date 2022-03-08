import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/model/post_filters/sensitive_post_filter.dart';
import 'package:kaiteki/ui/widgets/timeline.dart';

class TimelinePage extends ConsumerStatefulWidget {
  const TimelinePage({Key? key}) : super(key: key);

  @override
  _TimelinePageState createState() => _TimelinePageState();
}

class _TimelinePageState extends ConsumerState<TimelinePage> {
  @override
  Widget build(BuildContext context) {
    final adapter = ref.watch(adapterProvider);
    final timelineKey = ValueKey(adapter.client.hashCode);

    return Timeline(
      key: timelineKey,
      adapter: adapter,
      filters: [SensitivePostFilter()],
      maxWidth: 800,
    );
  }
}
