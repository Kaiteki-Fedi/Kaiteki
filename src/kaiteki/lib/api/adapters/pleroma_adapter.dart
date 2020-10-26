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

class PleromaAdapter extends SharedMastodonAdapter<PleromaClient> implements ChatSupport, ReactionSupport {
  PleromaAdapter._(PleromaClient client) : super(client);

  factory PleromaAdapter({PleromaClient client}) {
    return PleromaAdapter._(client ?? PleromaClient());
  }

  @override
  Future<ChatMessage> postChatMessage(Chat chat, ChatMessage message) async {
    // TODO: implement missing data, pleroma chat.
    var sentMessage = await client.postChatMessage(chat.id, message.content.content);
    return toChatMessage(sentMessage);
  }

  @override
  Future<User> getUser(String username, [String instance]) {
    // TODO: implement getUser
    throw UnimplementedError();
  }

  @override
  Future<Iterable<Reaction>> getReactions(Post post) {
    // TODO: implement getReactions
    throw UnimplementedError();
  }

  @override
  Future<void> react(Post post, Emoji emoji) {
    // TODO: implement react
    throw UnimplementedError();
  }

  @override
  bool supportsCustomEmoji = false;

  @override
  bool supportsUnicodeEmoji = true;

  @override
  Future<Iterable<ChatMessage>> getChatMessages(Chat chat) {
    // TODO: implement getChatMessages
    throw UnimplementedError();
  }

  @override
  Future<Iterable<Chat>> getChats() {
    // TODO: implement getChats
    throw UnimplementedError();
  }
}