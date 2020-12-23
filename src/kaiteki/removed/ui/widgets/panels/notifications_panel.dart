import 'package:flutter/material.dart';
import 'package:kaiteki/ui/pages/notifications_page.dart';
import 'package:kaiteki/ui/widgets/panels/panel_widget.dart';

class NotificationsPanel extends PanelWidget {
  NotificationsPanel()
      : super(
          title: Text("Notifications"),
          child: NotificationsPage(),
        );
}
