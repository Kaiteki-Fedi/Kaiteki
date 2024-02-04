import 'package:kaiteki_core/src/social/model/announcement.dart';

abstract class AnnouncementsSupport {
  Future<List<Announcement>> getAnnouncements();
}
