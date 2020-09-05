import 'package:flutter/material.dart';
import 'package:kaiteki/ui/widgets/panels/notifications_panel.dart';
import 'package:kaiteki/ui/widgets/panels/timeline_panel.dart';

class DeckPage extends StatelessWidget {
  DeckPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(8.0),
      children: [
        TimelinePanel(),
        NotificationsPanel(),
      ],
    );
  }
}
