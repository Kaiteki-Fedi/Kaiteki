import 'package:collection/collection.dart';
import 'package:fediverse_objects/pleroma.dart' as pleroma;
import 'package:kaiteki/fediverse/backends/mastodon/shared_adapter.dart';
import 'package:kaiteki/fediverse/backends/pleroma/capabilities.dart';
import 'package:kaiteki/fediverse/backends/pleroma/client.dart';
import 'package:kaiteki/fediverse/interfaces/chat_support.dart';
import 'package:kaiteki/fediverse/interfaces/preview_support.dart';
import 'package:kaiteki/fediverse/interfaces/reaction_support.dart';
import 'package:kaiteki/fediverse/model/model.dart';
import 'package:kaiteki/fediverse/model/notification.dart';

part 'adapter.c.dart';

// TODO(Craftplacer): add missing implementations
class PleromaAdapter //
    extends SharedMastodonAdapter<PleromaClient>
    implements ChatSupport, ReactionSupport, PreviewSupport {
  @override
  final String instance;

  factory PleromaAdapter(String instance) {
    return PleromaAdapter.custom(
      instance,
      PleromaClient(
        instance,
      ),
    );
  }

  PleromaAdapter.custom(this.instance, super.client);

  @override
  Future<ChatMessage> postChatMessage(Chat chat, ChatMessage message) async {
    // TODO(Craftplacer): implement missing data, pleroma chat.
    final sentMessage = await client.postChatMessage(
      chat.id,
      message.content.content!,
    );
    return toChatMessage(sentMessage);
  }

  @override
  Future<Iterable<ChatMessage>> getChatMessages(Chat chat) {
    throw UnimplementedError();
  }

  @override
  Future<Iterable<Chat>> getChats() {
    throw UnimplementedError();
  }

  @override
  Future<void> addReaction(Post post, covariant UnicodeEmoji emoji) async {
    await client.react(post.id, emoji.emoji);
  }

  @override
  Future<void> removeReaction(Post post, covariant UnicodeEmoji emoji) async {
    await client.removeReaction(post.id, emoji.emoji);
  }

  @override
  Future<Post> getPreview(PostDraft draft) async {
    final status = await client.postStatus(
      draft.content,
      contentType: getContentType(draft.formatting),
      pleromaPreview: true,
    );
    return toPost(status, instance);
  }

  @override
  Future<Instance?> probeInstance() async {
    final instance = await client.getInstance();

    if (!instance.version.contains("Pleroma")) {
      return null;
    }

    return _injectFE(toInstance(instance));
  }

  @override
  Future<Instance> getInstance() async {
    return _injectFE(toInstance(await client.getInstance()));
  }

  Future<Instance> _injectFE(Instance instance) async {
    final config = await client.getFrontendConfigurations();
    final pleroma = config.pleroma;

    final background = ensureAbsolute(pleroma?.background, this.instance);
    final logo = ensureAbsolute(pleroma?.logo, this.instance);

    return Instance(
      name: instance.name,
      source: instance,
      mascotUrl: instance.mascotUrl,
      backgroundUrl: background ?? instance.backgroundUrl,
      iconUrl: logo ?? instance.iconUrl,
    );
  }

  String? ensureAbsolute(String? input, String host) {
    if (input == null) {
      return null;
    }

    final uri = Uri.https(host, '');
    final relative = Uri.parse(input);

    if (!relative.isAbsolute) {
      final resolved = uri.resolveUri(relative);
      return resolved.toString();
    }

    return relative.toString();
  }

  @override
  PleromaCapabilities get capabilities => const PleromaCapabilities();

  @override
  Future<void> markAllNotificationsAsRead() async {
    final notifications = await client.getNotifications();
    final lastNotification = notifications.firstOrNull;
    if (lastNotification != null) {
      await client.markNotificationsAsRead(
        int.parse(lastNotification.id),
      );
    }
  }

  @override
  Future<void> markNotificationAsRead(Notification notification) {
    // TODO: implement markNotificationAsRead
    throw UnimplementedError();
  }
}
