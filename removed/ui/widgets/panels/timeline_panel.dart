import 'package:flutter/material.dart';
import 'package:kaiteki/ui/pages/timeline_page.dart';
import 'package:kaiteki/ui/widgets/panels/panel_widget.dart';

class TimelinePanel extends PanelWidget {
  TimelinePanel()
      : super(
          title: Text("Timeline"),
          child: TimelinePage(),
        );
}
