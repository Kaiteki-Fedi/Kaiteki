import 'package:fediverse_objects/pleroma.dart';
import 'package:kaiteki/fediverse/api/adapters/interfaces/chat_support.dart';
import 'package:kaiteki/fediverse/api/adapters/interfaces/reaction_support.dart';
import 'package:kaiteki/fediverse/api/adapters/mastodon/shared_adapter.dart';
import 'package:kaiteki/fediverse/api/clients/pleroma_client.dart';
import 'package:kaiteki/fediverse/model/chat.dart';
import 'package:kaiteki/fediverse/model/chat_message.dart';
import 'package:kaiteki/fediverse/model/emoji.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/fediverse/model/user.dart';

part 'adapter.c.dart';

// TODO add missing implementations
class PleromaAdapter extends SharedMastodonAdapter<PleromaClient>
    implements ChatSupport, ReactionSupport {
  PleromaAdapter._(PleromaClient client) : super(client);

  factory PleromaAdapter({PleromaClient client}) {
    return PleromaAdapter._(client ?? PleromaClient());
  }

  @override
  Future<ChatMessage> postChatMessage(Chat chat, ChatMessage message) async {
    // TODO implement missing data, pleroma chat.
    var sentMessage = await client.postChatMessage(
      chat.id,
      message.content.content,
    );
    return toChatMessage(sentMessage);
  }

  @override
  Future<User> getUser(String username, [String instance]) {
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
}
