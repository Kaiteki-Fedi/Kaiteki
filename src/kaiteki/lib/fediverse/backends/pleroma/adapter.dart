import 'package:fediverse_objects/pleroma.dart' as pleroma;
import 'package:kaiteki/fediverse/backends/mastodon/shared_adapter.dart';
import 'package:kaiteki/fediverse/backends/pleroma/client.dart';
import 'package:kaiteki/fediverse/interfaces/chat_support.dart';
import 'package:kaiteki/fediverse/interfaces/preview_support.dart';
import 'package:kaiteki/fediverse/interfaces/reaction_support.dart';
import 'package:kaiteki/fediverse/model/chat.dart';
import 'package:kaiteki/fediverse/model/chat_message.dart';
import 'package:kaiteki/fediverse/model/emoji.dart';
import 'package:kaiteki/fediverse/model/instance.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/fediverse/model/post_draft.dart';
import 'package:kaiteki/fediverse/model/user.dart';

part 'adapter.c.dart';

// TODO(Craftplacer): add missing implementations
class PleromaAdapter extends SharedMastodonAdapter<PleromaClient>
    implements ChatSupport, ReactionSupport, PreviewSupport {
  factory PleromaAdapter({PleromaClient? client}) {
    return PleromaAdapter._(client ?? PleromaClient());
  }

  PleromaAdapter._(PleromaClient client) : super(client);

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
  Future<User> getUser(String username, [String? instance]) {
    throw UnimplementedError();
  }

  @override
  bool supportsCustomEmoji = false;

  @override
  bool supportsUnicodeEmoji = true;

  @override
  Future<Iterable<ChatMessage>> getChatMessages(Chat chat) {
    throw UnimplementedError();
  }

  @override
  Future<Iterable<Chat>> getChats() {
    throw UnimplementedError();
  }

  @override
  Future<void> addReaction(Post post, Emoji emoji) {
    throw UnimplementedError();
  }

  @override
  Future<void> removeReaction(Post post, Emoji emoji) {
    throw UnimplementedError();
  }

  @override
  Future<Post> getPreview(PostDraft draft) async {
    final status = await client.postStatus(
      draft.content,
      contentType: getContentType(draft.formatting),
      pleromaPreview: true,
    );
    return toPost(status);
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

    final background = ensureAbsolute(pleroma?.background, client.instance);
    final logo = ensureAbsolute(pleroma?.logo, client.instance);

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
}
