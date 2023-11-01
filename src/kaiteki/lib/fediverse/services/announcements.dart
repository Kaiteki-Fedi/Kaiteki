import "package:kaiteki/account_manager.dart";
import "package:kaiteki/model/auth/account_key.dart";
import "package:kaiteki_core/social.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "announcements.g.dart";

@Riverpod(keepAlive: true)
class AnnouncementsService extends _$AnnouncementsService {
  late AnnouncementsSupport _backend;

  @override
  Future<List<Announcement>> build(AccountKey key) async {
    final account = ref
        .read(accountManagerProvider)
        .accounts
        .firstWhere((a) => a.key == key);
    _backend = account.adapter as AnnouncementsSupport;
    final announcements = await _backend.getAnnouncements();
    return announcements;
  }
}
