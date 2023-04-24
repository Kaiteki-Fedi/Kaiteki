import "package:fediverse_objects/mastodon.dart" as mastodon;
import "package:kaiteki/fediverse/api_type.dart";
import "package:kaiteki/fediverse/backends/glitch/capabilities.dart";
import "package:kaiteki/fediverse/backends/glitch/client.dart";
import "package:kaiteki/fediverse/backends/mastodon/shared_adapter.dart";
import "package:kaiteki/fediverse/interfaces/reaction_support.dart";

import "../../model/emoji/emoji.dart";
import "../../model/instance.dart";
import "../../model/notification.dart";
import "../../model/post/post.dart";

class GlitchAdapter extends SharedMastodonAdapter<GlitchClient>
    implements ReactionSupport {
  @override
  final String instance;
  final mastodon.Instance instanceInfo;

  static Future<GlitchAdapter> create(ApiType type, String instance) async {
    final cli = GlitchClient(instance);
    final instanceInfo = await cli.getInstance();
    return GlitchAdapter.custom(type, instance, instanceInfo, cli);
  }

  GlitchAdapter.custom(
    super.type,
    this.instance,
    this.instanceInfo,
    super.client,
  );

  @override
  GlitchCapabilities get capabilities {
    final maxReactions =
        instanceInfo.configuration.reactions?.maxReactions ?? 0;
    final supportsReactions = maxReactions != 0;

    return GlitchCapabilities(supportsReactions);
  }

  @override
  Future<Instance?> probeInstance() async {
    if (!instanceInfo.version.contains("+glitch")) {
      return null;
    }

    return toInstance(instanceInfo, instance);
  }

  @override
  Future<Instance> getInstance() async {
    return toInstance(instanceInfo, instance);
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

  @override
  Future<void> addReaction(Post post, Emoji emoji) async {
    await client.react(post.id, emoji.getTag(instance));
  }

  @override
  Future<void> removeReaction(Post post, Emoji emoji) async {
    await client.removeReaction(post.id, emoji.getTag(instance));
  }
}
