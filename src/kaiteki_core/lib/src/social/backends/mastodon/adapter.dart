import 'package:kaiteki_core/kaiteki_core.dart';

import 'client.dart';
import 'extensions.dart';
import 'shared_adapter.dart';

class MastodonAdapter extends SharedMastodonAdapter<MastodonClient>
    implements ExploreSupport {
  @override
  final String instance;

  static Future<MastodonAdapter> create(ApiType type, String instance) async {
    return MastodonAdapter.custom(type, instance, MastodonClient(instance));
  }

  MastodonAdapter.custom(super.type, this.instance, super.client);

  @override
  Future<Instance?> probeInstance() async {
    final instance = await client.getInstance();
    return instance.toKaiteki(this.instance);
  }

  @override
  Future<Instance> getInstance() async {
    var instance = await client.getInstance();
    return instance.toKaiteki(this.instance);
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
      'Mastodon does not support marking individual notifications as read',
    );
  }

  @override
  Future<List<Post>> getTrendingPosts() async {
    final statuses = await client.getTrendingStatuses();
    return statuses.map((e) => e.toKaiteki(instance)).toList();
  }

  @override
  Future<List<Embed>> getTrendingLinks() async {
    final links = await client.getTrendingLinks();
    return links.map((e) => e.toKaiteki()).toList();
  }

  @override
  Future<List<String>> getTrendingHashtags() async {
    final tags = await client.getTrendingTags();
    return tags.map((t) => t.name).toList();
  }
}
