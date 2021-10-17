import 'package:fediverse_objects/misskey.dart';
import 'package:kaiteki/account_manager.dart';
import 'package:kaiteki/fediverse/api/adapters/fediverse_adapter.dart';
import 'package:kaiteki/fediverse/api/adapters/interfaces/chat_support.dart';
import 'package:kaiteki/fediverse/api/adapters/interfaces/reaction_support.dart';
import 'package:kaiteki/fediverse/api/clients/misskey_client.dart';
import 'package:kaiteki/fediverse/api/requests/misskey/sign_in.dart';
import 'package:kaiteki/fediverse/api/requests/misskey/timeline.dart';
import 'package:kaiteki/fediverse/model/attachment.dart';
import 'package:kaiteki/fediverse/model/chat.dart';
import 'package:kaiteki/fediverse/model/chat_message.dart';
import 'package:kaiteki/fediverse/model/emoji.dart';
import 'package:kaiteki/fediverse/model/emoji_category.dart';
import 'package:kaiteki/fediverse/model/instance.dart';
import 'package:kaiteki/fediverse/model/notification.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/fediverse/model/post_draft.dart';
import 'package:kaiteki/fediverse/model/reaction.dart';
import 'package:kaiteki/fediverse/model/timeline_type.dart';
import 'package:kaiteki/fediverse/model/user.dart';
import 'package:kaiteki/fediverse/model/visibility.dart';
import 'package:kaiteki/model/auth/account_compound.dart';
import 'package:kaiteki/model/auth/account_secret.dart';
import 'package:kaiteki/model/auth/authentication_data.dart';
import 'package:kaiteki/model/auth/client_secret.dart';
import 'package:kaiteki/model/auth/login_result.dart';
import 'package:kaiteki/utils/extensions/iterable.dart';

part 'adapter.c.dart';

// TODO add missing implementations
class MisskeyAdapter extends FediverseAdapter<MisskeyClient>
    implements ChatSupport, ReactionSupport {
  MisskeyAdapter._(MisskeyClient client) : super(client);

  factory MisskeyAdapter({MisskeyClient? client}) {
    return MisskeyAdapter._(client ?? MisskeyClient());
  }

  @override
  Future<User> getUser(String username, [String? instance]) async {
    var mkUser = await client.showUserByName(username, instance);
    return toUser(mkUser);
  }

  @override
  Future<User> getUserById(String id) async {
    return toUser((await client.showUser(id))!);
  }

  @override
  Future<LoginResult> login(
    String instance,
    String username,
    String password,
    mfaCallback,
    AccountManager accounts,
  ) async {
    client.instance = instance;

    var authResponse = await client.signIn(
      MisskeySignInRequest(
        username: username,
        password: password,
      ),
    );

    var mkClientSecret = ClientSecret(instance, "", "", apiType: client.type);

    // Create and set account secret
    var accountSecret = AccountSecret(instance, username, authResponse.i);
    client.authenticationData =
        MisskeyAuthenticationData(accountSecret.accessToken);

    // Check whether secrets work, and if we can get an account back
    var account = await client.showUser(authResponse.id);
    if (account == null) {
      return LoginResult.failed("Failed to retrieve user info");
    }

    var compound = AccountCompound(
      container: accounts,
      adapter: this,
      account: toUser(account),
      clientSecret: mkClientSecret,
      accountSecret: accountSecret,
    );
    await accounts.addCurrentAccount(compound);

    return LoginResult.successful();
  }

  @override
  Future<Post> postStatus(PostDraft draft, {Post? parentPost}) {
    throw UnimplementedError();
  }

  @override
  Future<User> getMyself() async {
    return toUser(await client.i());
  }

  @override
  Future<Iterable<Chat>> getChats() {
    throw UnimplementedError();
  }

  @override
  Future<Iterable<Post>> getTimeline(TimelineType type,
      {String? sinceId, String? untilId}) async {
    Iterable<MisskeyNote> notes;

    var request = MisskeyTimelineRequest(sinceId: sinceId, untilId: untilId);
    switch (type) {
      case TimelineType.home:
        notes = await client.getTimeline(request);
        break;

      default:
        throw UnimplementedError(
          "Fetching of timeline type $type is not implemented yet.",
        );
    }

    return notes.map(toPost);
  }

  @override
  Future<Iterable<ChatMessage>> getChatMessages(Chat chat) {
    throw UnimplementedError();
  }

  @override
  Future<Iterable<Notification>> getNotifications() {
    throw UnimplementedError();
  }

  @override
  Future<Iterable<Post>> getStatusesOfUserById(String id) async {
    var notes = await client.showUserNotes(id, true, [
      "image/jpeg",
      "image/png",
      "image/gif",
      "image/apng",
      "image/vnd.mozilla.apng"
    ]);
    return notes.map(toPost);
  }

  @override
  Future<ChatMessage> postChatMessage(Chat chat, ChatMessage message) {
    throw UnimplementedError();
  }

  @override
  bool supportsCustomEmoji = true;

  @override
  bool supportsUnicodeEmoji = true;

  @override
  Future<void> addReaction(Post post, Emoji emoji) async {
    var note = post.source as MisskeyNote;

    String emojiName;

    if (emoji is CustomEmoji) {
      emojiName = ':' + emoji.name + ':';
    } else if (emoji is UnicodeEmoji) {
      emojiName = emoji.source!;
    } else {
      return;
    }

    await client.createReaction(note.id, emojiName);
  }

  @override
  Future<void> removeReaction(Post post, Emoji emoji) async {
    var note = post.source as MisskeyNote;

    // The "emoji" parameter is ignored,
    // because in Misskey you can only react once.
    await client.deleteReaction(note.id);
  }

  @override
  Future<Iterable<EmojiCategory>> getEmojis() async {
    var instanceMeta = await client.getInstanceMeta();
    var emojiCategories = instanceMeta.emojis.groupBy((e) => e.category);
    return emojiCategories.entries.map(
      (kv) => EmojiCategory(kv.key!, kv.value.map(toEmoji)),
    );
  }

  @override
  Future<Iterable<Post>> getThread(Post reply) async {
    var notes = await client.getConversation(reply.id);
    return notes.map(toPost).followedBy([reply]);
  }

  @override
  Future<Instance> getInstance() async {
    return toInstance(await client.getInstanceMeta(), client.baseUrl);
  }

  @override
  Future<Instance> probeInstance() async {
    return getInstance();
  }
}
