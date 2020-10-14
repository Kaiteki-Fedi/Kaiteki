import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kaiteki/model/fediverse/notification.dart' as fv;
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class NotificationPoster {
  static Future<void> sendNotifications(BuildContext context, Iterable<fv.Notification> notifications) async {
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

  static Future<void> sendNotification(FlutterLocalNotificationsPlugin plugin, fv.Notification data) async {
    const String notificationsKey = "craftplacer.kaiteki.NOTIFICATIONS";

    var avatarResponse = await http.get(data.user.avatarUrl);
    var iconPath = Directory.systemTemp.path + '/' + data.user.avatarUrl.hashCode.toString();
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
      importance: Importance.max,
      priority: Priority.high,
      category: "Test",
      groupKey: notificationsKey,
      ticker: 'ticker',
      color: getColor(data.type),
      largeIcon: FilePathAndroidBitmap(iconPath),
    );

    await plugin.show(
      data.hashCode,
      getTitle(data),
      data.post.content,
      NotificationDetails(android: android),
    );
  }

  static String getTitle(fv.Notification notification) {
    var name = notification.user.displayName;

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