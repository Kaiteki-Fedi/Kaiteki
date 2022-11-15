import 'package:kaiteki/fediverse/model/notification.dart';

abstract class NotificationSupport {
  Future<List<Notification>> getNotifications();
}
