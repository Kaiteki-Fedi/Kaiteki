import 'package:fediverse_objects/pleroma/chat_message.dart';
import 'package:kaiteki/api/adapters/interfaces/chat_support.dart';
import 'package:kaiteki/api/adapters/interfaces/reaction_support.dart';
import 'package:kaiteki/api/adapters/shared_mastodon_adapter.dart';
import 'package:kaiteki/api/clients/pleroma_client.dart';
import 'package:kaiteki/model/fediverse/chat.dart';
import 'package:kaiteki/model/fediverse/chat_message.dart';
import 'package:kaiteki/model/fediverse/emoji.dart';
import 'package:kaiteki/model/fediverse/post.dart';
import 'package:kaiteki/model/fediverse/reaction.dart';
import 'package:kaiteki/model/fediverse/user.dart';

part 'pleroma_adapter.c.dart';

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
