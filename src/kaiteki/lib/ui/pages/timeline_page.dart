import 'package:flutter/material.dart';
import 'package:kaiteki/account_manager.dart';
import 'package:kaiteki/model/post_filters/sensitive_post_filter.dart';
import 'package:kaiteki/ui/widgets/timeline.dart';
import 'package:provider/provider.dart';

class TimelinePage extends StatefulWidget {
  const TimelinePage({Key? key}) : super(key: key);

  @override
  _TimelinePageState createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  @override
  Widget build(BuildContext context) {
    var container = Provider.of<AccountManager>(context);
    var timelineKey = ValueKey(container.currentAccount.hashCode);

    return Timeline(
      key: timelineKey,
      adapter: container.adapter,
      filters: [SensitivePostFilter()],
      maxWidth: 800,
    );
  }
}
