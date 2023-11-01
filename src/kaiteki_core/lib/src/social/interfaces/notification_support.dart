import 'package:kaiteki_core/src/social/model/notification.dart';

abstract class NotificationSupport {
  Future<List<Notification>> getNotifications({
    String? sinceId,
    String? untilId,
  });

  Future<void> clearAllNotifications();

  Future<void> markAllNotificationsAsRead();

  Future<void> markNotificationAsRead(Notification notification);
}
