import 'package:kaiteki/fediverse/backends/mastodon/client.dart';
import 'package:kaiteki/fediverse/backends/mastodon/shared_adapter.dart';
import 'package:kaiteki/fediverse/model/instance.dart';
import 'package:kaiteki/fediverse/model/notification.dart';

class MastodonAdapter extends SharedMastodonAdapter<MastodonClient> {
  factory MastodonAdapter(String instance) {
    return MastodonAdapter.custom(MastodonClient(instance));
  }

  MastodonAdapter.custom(super.client);

  @override
  Future<Instance?> probeInstance() async {
    final instance = await client.getInstance();
    if (instance.version.contains("Pleroma")) {
      return null;
    }

    return toInstance(instance);
  }

  @override
  Future<Instance> getInstance() async {
    return toInstance(await client.getInstance());
  }

  @override
  Future<void> markAllNotificationsAsRead() async {
    throw UnimplementedError();
  }

  @override
  Future<void> markNotificationAsRead(Notification notification) {
    throw UnsupportedError(
      "Mastodon does not support marking individual notifications as read",
    );
  }
}
