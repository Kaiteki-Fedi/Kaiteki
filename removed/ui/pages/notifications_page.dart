import 'package:flutter/material.dart' hide Notification;
import 'package:kaiteki/account_container.dart';
import 'package:kaiteki/model/fediverse/notification.dart';
import 'package:kaiteki/notification_poster.dart';
import 'package:kaiteki/ui/widgets/icon_landing_widget.dart';
import 'package:kaiteki/ui/widgets/interaction_bar.dart';
import 'package:kaiteki/ui/widgets/status_widget.dart';
import 'package:mdi/mdi.dart';
import 'package:provider/provider.dart';

class NotificationsPage extends StatefulWidget {
  NotificationsPage({Key key}) : super(key: key);

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    var container = Provider.of<AccountContainer>(context);

    if (!container.loggedIn)
      return Center(
          child: IconLandingWidget(
              icon: Mdi.key,
              text: "You need to be signed in to view your notifications"));

    return FutureBuilder(
      future: container.adapter.getNotifications(),
      builder: (_, AsyncSnapshot<Iterable<Notification>> snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        NotificationPoster.sendNotifications(context, snapshot.data)
            .then((value) => null);

        return ListView(
          children: [
            for (var notification in snapshot.data)
              Column(
                children: [
                  getInteractionBar(notification),
                  if (notification.post != null)
                    StatusWidget(notification.post),
                  Divider(),
                ],
              )
          ],
        );
      },
    );
  }

  InteractionBar getInteractionBar(Notification notification) {
    switch (notification.type) {
      case "follow":
        {
          return InteractionBar(
              color: Colors.lightBlueAccent,
              icon: Mdi.accountPlus,
              text: "followed you",
              user: notification.user);
        }
      case "favourite":
        {
          return InteractionBar(
              color: Colors.yellowAccent,
              icon: Mdi.star,
              text: "favorited your status",
              user: notification.user);
        }
      case "reblog":
        {
          return InteractionBar(
              color: Colors.lightGreenAccent,
              icon: Mdi.repeat,
              text: "repeated your status",
              user: notification.user);
        }
      case "mention":
        {
          return InteractionBar(
              color: Colors.indigoAccent,
              icon: Mdi.reply,
              text: "replied to you",
              user: notification.user);
        }

      default:
        {
          return InteractionBar(
              color: Colors.grey,
              icon: Mdi.help,
              text:
                  "had an unknown interaction with you (${notification.type})",
              user: notification.user);
        }
    }
  }
}
