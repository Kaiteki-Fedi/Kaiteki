import 'package:flutter/material.dart' hide Notification;
import 'package:kaiteki/account_container.dart';
import 'package:kaiteki/api/clients/pleroma_client.dart';
import 'package:kaiteki/ui/widgets/icon_landing_widget.dart';
import 'package:kaiteki/ui/widgets/interaction_bar.dart';
import 'package:kaiteki/ui/widgets/status_widget.dart';
import 'package:mdi/mdi.dart';
import 'package:provider/provider.dart';
import 'package:kaiteki/api/model/mastodon/notification.dart';


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
              Mdi.key,
              "You need to be signed in to view your notifications"
          )
      );

    if (!(container.client is PleromaClient))
      return Center(
          child: IconLandingWidget(
              Mdi.emoticonFrown,
              "Unsupported client"
          )
      );

    var pleroma = container.client as PleromaClient;

    return FutureBuilder(
      future: pleroma.getNotifications(),
      builder: (_, AsyncSnapshot<Iterable<MastodonNotification>> snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        return ListView(
          children: [
            for (var notification in snapshot.data)
              Column(
                children: [
                  getInteractionBar(notification),
                  if (notification.status != null)
                    StatusWidget(notification.status),
                  Divider(),
                ],
              )
          ],
        );
      },
    );
  }

  InteractionBar getInteractionBar(MastodonNotification notification) {
    switch (notification.type) {
      case "follow": {
        return InteractionBar(
            color: Colors.lightBlueAccent,
            icon: Mdi.accountPlus,
            text: "followed you",
            account: notification.account
        );
      }
      case "favourite": {
        return InteractionBar(
            color: Colors.yellowAccent,
            icon: Mdi.star,
            text: "favorited your status",
            account: notification.account
        );
      }
      case "reblog": {
        return InteractionBar(
            color: Colors.lightGreenAccent,
            icon: Mdi.repeat,
            text: "repeated your status",
            account: notification.account
        );
      }
      case "mention": {
        return InteractionBar(
            color: Colors.indigoAccent,
            icon: Mdi.reply,
            text: "replied to you",
            account: notification.account
        );
      }

      default: {
        return InteractionBar(
            color: Colors.grey,
            icon: Mdi.help,
            text: "had an unknown interaction with you (${notification.type})",
            account: notification.account
        );
      }
    }
  }
}