import 'package:flutter/material.dart';
import 'package:kaiteki/account_container.dart';
import 'package:kaiteki/model/post_filters/sensitive_post_filter.dart';
import 'package:kaiteki/ui/widgets/icon_landing_widget.dart';
import 'package:kaiteki/ui/widgets/timeline.dart';
import 'package:mdi/mdi.dart';
import 'package:provider/provider.dart';

class TimelinePage extends StatefulWidget {
  TimelinePage({Key key}) : super(key: key);

  @override
  _TimelinePageState createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  @override
  Widget build(BuildContext context) {
    var container = Provider.of<AccountContainer>(context);

    if (container.loggedIn) {
      return Timeline(
        key: ValueKey(container.currentAccount.hashCode),
        adapter: container.adapter,
        filters: [SensitivePostFilter()],
      );
    } else {
      return Center(
        child: IconLandingWidget(
          icon: Mdi.key,
          text: "You need to be signed in to view your timeline",
        ),
      );
    }
  }
}
