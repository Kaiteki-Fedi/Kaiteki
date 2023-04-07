import "package:kaiteki/fediverse/backends/mastodon/client.dart";
import "package:kaiteki/fediverse/backends/mastodon/shared_adapter.dart";
import "package:kaiteki/fediverse/model/instance.dart";
import "package:kaiteki/fediverse/model/notification.dart";

class MastodonAdapter extends SharedMastodonAdapter<MastodonClient> {
  @override
  final String instance;

  static Future<MastodonAdapter> create(String instance) async {
    return MastodonAdapter.custom(instance, MastodonClient(instance));
  }

  MastodonAdapter.custom(this.instance, super.client);

  @override
  Future<Instance?> probeInstance() async {
    final instance = await client.getInstance();

    if (instance.version.contains("Pleroma") ||
        instance.version.contains("+glitch")) {
      return null;
    }

    return toInstance(instance);
  }

  @override
  Future<Instance> getInstance() async {
    return toInstance(await client.getInstance());
  }

  @override
  Future<void> deleteAccount(String password) {
    // TODO(Craftplacer): implement deleteAccount
    throw UnimplementedError();
  }

  @override
  Future<void> markAllNotificationsAsRead() async {
    // HACK(Craftplacer): refetching latest notifcation will mark previously unfetched notifications as read as well
    final latest = await client.getNotifications(limit: 1);
    if (latest.isEmpty) return;
    await client.setMarkerPosition(notifications: latest.first.id);
  }

  @override
  Future<void> markNotificationAsRead(Notification notification) {
    throw UnsupportedError(
      "Mastodon does not support marking individual notifications as read",
    );
  }
}
