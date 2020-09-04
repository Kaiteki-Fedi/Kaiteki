import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kaiteki/api/model/mastodon/notification.dart';
import 'package:provider/provider.dart';

class NotificationPoster {
  static Future<void> sendNotifications(BuildContext context, Iterable<MastodonNotification> notifications) async {
    var plugin = Provider.of<FlutterLocalNotificationsPlugin>(context, listen: false);

    for (var notification in notifications.take(3)) {
      await sendNotification(plugin, notification);
    }
  }

  static Color getColor(String type) {
    switch (type) {
      case "follow":
        return Colors.lightBlue;

      case "favourite":
        return Colors.yellow;

      case "reblog":
        return Colors.lightGreen;

      case "mention":
        return Colors.indigo;

      default:
        return Colors.grey;
    }
  }

  static Future<void> sendNotification(FlutterLocalNotificationsPlugin plugin, MastodonNotification data) async {
    const String notificationsKey = "craftplacer.kaiteki.NOTIFICATIONS";

    var avatarResponse = await http.get(data.account.avatarStatic);
    var iconPath = Directory.systemTemp.path + '/' + data.account.avatarStatic.hashCode.toString();
    var iconFile = File(iconPath);

    if (!(await iconFile.exists())) {
      print("downloading to $iconPath");
      await iconFile.writeAsBytes(
        avatarResponse.bodyBytes,
        flush: true
      );
    }


    var android = AndroidNotificationDetails(
      data.type,
      data.type,
      'Notifications with the type ${data.type}',
      importance: Importance.Max,
      priority: Priority.High,
      category: "Test",
      groupKey: notificationsKey,
      ticker: 'ticker',
      color: getColor(data.type),
      largeIcon: FilePathAndroidBitmap(iconPath),
    );
    var details = NotificationDetails(
      android,
      IOSNotificationDetails(),
    );

    await plugin.show(
      data.hashCode,
      getTitle(data),
      data.status.content,
      details
    );
  }

  static String getTitle(MastodonNotification notification) {
    var name = notification.account.displayName;

    switch (notification.type) {
      case "follow":
        return "$name followed you";

      case "favourite":
        return "$name favorited your status";

      case "reblog":
        return "$name repeated your status";

      case "mention":
        return "$name replied to you";

      default:
        return "$name had an unknown interaction with you (${notification.type})";
    }
  }
}