import 'package:fediverse_objects/pleroma.dart' as pleroma;
import 'package:kaiteki_core/social.dart';
import 'package:kaiteki_core_backends/src/mastodon/extensions.dart';
import 'package:kaiteki_core_backends/src/mastodon/shared_adapter.dart';

import 'extensions.dart';
import 'capabilities.dart';
import 'client.dart';

class PleromaAdapter //
    extends SharedMastodonAdapter<PleromaClient>
    implements
        ChatSupport,
        ReactionSupport,
        PreviewSupport,
        AccountDeletionSupport {
  @override
  final PleromaCapabilities capabilities;

  static Future<PleromaAdapter> create(String instance) async {
    final client = PleromaClient(instance);
    final instanceInfo = await client.getInstanceV1();
    return PleromaAdapter._(
      client,
      PleromaCapabilities.fromInstance(instanceInfo),
    );
  }

  PleromaAdapter._(super.client, this.capabilities);

  @override
  Future<ChatMessage> postChatMessage(
    ChatTarget chat,
    ChatMessage message,
  ) async {
    // TODO(Craftplacer): implement missing data, pleroma chat.
    final currentAccount = await client.verifyCredentials();
    final currentUser = currentAccount.toKaiteki(instance);

    final sentMessage = await client.postChatMessage(
      chat.id,
      message.content!,
    );

    final pleromaChat = chat.source as pleroma.Chat;
    return sentMessage.toKaiteki(pleromaChat, currentUser);
  }

  @override
  Future<Iterable<ChatMessage>> getChatMessages(ChatTarget chat) async {
    final currentAccount = await client.verifyCredentials();
    final currentUser = currentAccount.toKaiteki(instance);
    final messages = await client.getChatMessages(chat.id);
    final pleromaChat = chat.source as pleroma.Chat;
    return messages.map((msg) => msg.toKaiteki(pleromaChat, currentUser));
  }

  @override
  Future<Iterable<ChatTarget>> getChats() async {
    final currentAccount = await client.verifyCredentials();
    final currentUser = currentAccount.toKaiteki(instance);
    final chats = await client.getChats();
    return chats.map((chat) => chat.toKaiteki(currentUser, instance));
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
    return status.toKaiteki(instance);
  }

  @override
  Future<Instance> getInstance() async {
    final instance = await client.getInstanceV1();
    return _injectFE(instance.toKaiteki(this.instance));
  }

  Future<Instance> _injectFE(Instance instance) async {
    final config = await client.getFrontendConfigurations();
    final pleroma = config.pleroma;

    Uri? ensureAbsolute(Uri? input, String host) {
      if (input == null) return null;
      if (!input.isAbsolute) return Uri.https(host).resolveUri(input);
      return input;
    }

    final background = ensureAbsolute(pleroma?.background, this.instance);
    final logo = ensureAbsolute(pleroma?.logo, this.instance);

    return Instance(
      name: instance.name,
      source: instance.source,
      mascotUrl: instance.mascotUrl,
      backgroundUrl: background ?? instance.backgroundUrl,
      iconUrl: logo ?? instance.iconUrl,
      administrators: instance.administrators,
      moderators: instance.moderators,
      description: instance.description,
      postCount: instance.postCount,
      userCount: instance.userCount,
      tosUrl: instance.tosUrl ??
          Uri.https(
            this.instance,
            '/static/terms-of-service.html',
          ),
    );
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
