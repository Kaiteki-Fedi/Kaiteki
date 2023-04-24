import "package:collection/collection.dart";
import "package:fediverse_objects/pleroma.dart" as pleroma;
import "package:kaiteki/fediverse/api_type.dart";
import "package:kaiteki/fediverse/backends/mastodon/shared_adapter.dart";
import "package:kaiteki/fediverse/backends/pleroma/capabilities.dart";
import "package:kaiteki/fediverse/backends/pleroma/client.dart";
import "package:kaiteki/fediverse/interfaces/chat_support.dart";
import "package:kaiteki/fediverse/interfaces/preview_support.dart";
import "package:kaiteki/fediverse/interfaces/reaction_support.dart";
import "package:kaiteki/fediverse/model/model.dart";
import "package:kaiteki/fediverse/model/notification.dart";
import "package:kaiteki/utils/extensions.dart";

part "adapter.c.dart";

class PleromaAdapter //
    extends SharedMastodonAdapter<PleromaClient>
    implements ChatSupport, ReactionSupport, PreviewSupport {
  @override
  final PleromaCapabilities capabilities;

  static Future<PleromaAdapter> create(ApiType type, String instance) async {
    final client = PleromaClient(instance);
    final instanceInfo = await client.getInstanceV1();
    return PleromaAdapter._(
      type,
      client,
      PleromaCapabilities.fromInstance(instanceInfo),
    );
  }

  PleromaAdapter._(super.type, super.client, this.capabilities);

  @override
  Future<ChatMessage> postChatMessage(
    ChatTarget chat,
    ChatMessage message,
  ) async {
    // TODO(Craftplacer): implement missing data, pleroma chat.
    final currentAccount = toUser(await client.verifyCredentials(), instance);

    final sentMessage = await client.postChatMessage(
      chat.id,
      message.content!,
    );

    final pleromaChat = chat.source as pleroma.Chat;
    return toChatMessage(sentMessage, pleromaChat, currentAccount);
  }

  @override
  Future<Iterable<ChatMessage>> getChatMessages(ChatTarget chat) async {
    final currentAccount = toUser(await client.verifyCredentials(), instance);
    final messages = await client.getChatMessages(chat.id);
    final pleromaChat = chat.source as pleroma.Chat;
    return messages
        .map((msg) => toChatMessage(msg, pleromaChat, currentAccount));
  }

  @override
  Future<Iterable<ChatTarget>> getChats() async {
    final currentAccount = toUser(await client.verifyCredentials(), instance);
    final chats = await client.getChats();
    return chats.map((chat) => toChatTarget(chat, currentAccount, instance));
  }

  @override
  Future<void> addReaction(Post post, Emoji emoji) async {
    await client.react(post.id, emoji.short);
  }

  @override
  Future<void> removeReaction(Post post, Emoji emoji) async {
    await client.removeReaction(post.id, emoji.short);
  }

  @override
  Future<Post> getPreview(PostDraft draft) async {
    final status = await client.postStatus(
      draft.content,
      contentType: pleromaFormattingRosetta.getLeft(draft.formatting),
      pleromaPreview: true,
    );
    return toPost(status, instance);
  }

  @override
  Future<Instance?> probeInstance() async {
    final instance = await client.getInstanceV1();

    if (!instance.version.contains("Pleroma")) {
      return null;
    }

    return _injectFE(toInstanceFromV1(instance, this.instance));
  }

  @override
  Future<Instance> getInstance() async {
    return _injectFE(toInstanceFromV1(await client.getInstanceV1(), instance));
  }

  Future<Instance> _injectFE(Instance instance) async {
    final config = await client.getFrontendConfigurations();
    final pleroma = config.pleroma;

    final background = ensureAbsolute(pleroma?.background, this.instance);
    final logo = ensureAbsolute(pleroma?.logo, this.instance);

    return Instance(
      name: instance.name,
      source: instance.source,
      mascotUrl: instance.mascotUrl,
      backgroundUrl: background ?? instance.backgroundUrl,
      iconUrl: logo ?? instance.iconUrl,
      administrator: instance.administrator,
      description: instance.description,
      postCount: instance.postCount,
      userCount: instance.userCount,
    );
  }

  Uri? ensureAbsolute(String? input, String host) {
    if (input == null) return null;

    final uri = Uri.https(host);
    final relative = Uri.parse(input);

    if (!relative.isAbsolute) return uri.resolveUri(relative);

    return relative;
  }

  @override
  Future<void> deleteAccount(String password) async {
    await client.deleteAccount(password);
  }

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
    // TODO(Craftplacer): implement markNotificationAsRead
    throw UnimplementedError();
  }
}
