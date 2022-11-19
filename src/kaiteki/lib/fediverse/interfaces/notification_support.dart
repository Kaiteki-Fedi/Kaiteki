import 'package:kaiteki/fediverse/model/notification.dart';

abstract class NotificationSupport {
  Future<List<Notification>> getNotifications();
  Future<void> clearAllNotifications();
  Future<void> markAllNotificationsAsRead();
  Future<void> markNotificationAsRead(Notification notification);
}
