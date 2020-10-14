import 'package:kaiteki/account_container.dart';
import 'package:kaiteki/adapters/fediverse_adapter.dart';
import 'package:kaiteki/adapters/interfaces/chat_support.dart';
import 'package:kaiteki/api/api_type.dart';
import 'package:kaiteki/api/clients/misskey_client.dart';
import 'package:kaiteki/api/model/misskey/emoji.dart';
import 'package:kaiteki/api/model/misskey/note.dart';
import 'package:kaiteki/api/model/misskey/user.dart';
import 'package:kaiteki/model/auth/account_compound.dart';
import 'package:kaiteki/model/auth/account_secret.dart';
import 'package:kaiteki/model/auth/authentication_data.dart';
import 'package:kaiteki/model/auth/client_secret.dart';
import 'package:kaiteki/model/auth/login_result.dart';
import 'package:kaiteki/model/fediverse/chat.dart';
import 'package:kaiteki/model/fediverse/chat_message.dart';
import 'package:kaiteki/model/fediverse/emoji.dart';
import 'package:kaiteki/model/fediverse/notification.dart';
import 'package:kaiteki/model/fediverse/post.dart';
import 'package:kaiteki/model/fediverse/reaction.dart';
import 'package:kaiteki/model/fediverse/timeline_type.dart';
import 'package:kaiteki/model/fediverse/user.dart';

class MisskeyAdapter extends FediverseAdapter<MisskeyClient> implements ChatSupport {
  MisskeyAdapter() : super(MisskeyClient());

  @override
  Future<User> getUser(String username, [String instance]) async {
    var mkUser = await client.showUserByName(username, instance);
    return toUser(mkUser);
  }

  @override
  Future<User> getUserById(String id) async {
    return toUser(await client.showUser(id));
  }

  // CONVERSIONS
  Post toPost(MisskeyNote source) {
    assert(source != null);

    var mappedEmoji = source.emojis.map(toEmoji);

    return Post(
      source: source,
      postedAt: source.createdAt,
      author: toUser(source.user),
      liked: false,
      repeated: false,
      content: source.text,
      emojis: mappedEmoji,
      reactions: source.reactions.entries.map((mkr) {
        return Reaction(
          count: mkr.value,
          includesMe: false,
          users: [],
          emoji: getEmojiFromString(mkr.key, mappedEmoji)
        );
      }),
    );
  }

  Emoji getEmojiFromString(String emojiString, Iterable<Emoji> inheritingEmoji) {
    if (emojiString.startsWith(":") && emojiString.endsWith(":")) {
      var matchingEmoji = inheritingEmoji.firstWhere((e) => e.name == emojiString.substring(1, emojiString.length-1));

      return matchingEmoji;
    }

    return UnicodeEmoji(emojiString, null, aliases: null);
  }

  CustomEmoji toEmoji(MisskeyEmoji emoji) {
    return CustomEmoji(
      source: emoji,
      name: emoji.name,
      url: emoji.url,
      aliases: emoji.aliases,
    );
  }

  User toUser(MisskeyUser source) {
    assert(source != null);

    return User(
      source: source,
      username: source.username,
      displayName: source.name ?? source.username,
      joinDate: source.createdAt,
      emojis: source.emojis.map(toEmoji),
      avatarUrl: source.avatarUrl,
      bannerUrl: source.bannerUrl,
      id: source.id,
      description: source.description,
    );
  }

  @override
  Future<LoginResult> login(String instance, String username, String password, mfaCallback, AccountContainer accounts) async {
    client.instance = instance;

    var authResponse = await client.signIn(
      username,
      password,
    );

    var mkClientSecret = ClientSecret(instance, "", "", apiType: ApiType.Misskey);

    // Create and set account secret
    var accountSecret = new AccountSecret(instance, username, authResponse.i);
    client.authenticationData = MisskeyAuthenticationData(accountSecret.accessToken);

    // Check whether secrets work, and if we can get an account back
    var account = await client.showUser(authResponse.id);
    if (account == null) {
      return LoginResult.failed("Failed to retrieve user info");
    }

    var compound = AccountCompound(accounts, this, toUser(account), mkClientSecret, accountSecret);
    await accounts.addCurrentAccount(compound);

    return LoginResult.successful();
  }

  @override
  Future<Post> postStatus(Post post) {
    // TODO: implement postStatus
    throw UnimplementedError();
  }

  @override
  Future<User> getMyself() {
    // TODO: implement verifyCredentials
    throw UnimplementedError();
  }

  @override
  Future<Iterable<Chat>> getChats() {
    // TODO: implement getChats
    throw UnimplementedError();
  }

  @override
  Future<Iterable<Post>> getTimeline(TimelineType type) async {
    var notes = await client.getTimeline();
    return notes.map(toPost);
  }

  @override
  Future<Iterable<ChatMessage>> getChatMessages(Chat chat) {
    throw UnimplementedError();
  }

  @override
  Future<Iterable<Notification>> getNotifications() {
    // TODO: implement getNotifications
    throw UnimplementedError();
  }

  @override
  Future<Iterable<Post>> getStatusesOfUserById(String id) async {
    var notes = await client.showUserNotes(id, true, ["image/jpeg", "image/png","image/gif", "image/apng", "image/vnd.mozilla.apng"]);
    return notes.map(toPost);
  }

  @override
  Future<ChatMessage> postChatMessage(Chat chat, ChatMessage message) {
    // TODO: implement postChatMessage
    throw UnimplementedError();
  }
}


