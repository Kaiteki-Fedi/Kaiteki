import 'package:fediverse_objects/misskey/file.dart';
import 'package:kaiteki/account_container.dart';
import 'package:kaiteki/api/adapters/fediverse_adapter.dart';
import 'package:kaiteki/api/adapters/interfaces/chat_support.dart';
import 'package:kaiteki/api/adapters/interfaces/reaction_support.dart';
import 'package:kaiteki/api/clients/misskey_client.dart';
import 'package:fediverse_objects/misskey/emoji.dart';
import 'package:fediverse_objects/misskey/note.dart';
import 'package:fediverse_objects/misskey/user.dart';
import 'package:kaiteki/api/requests/misskey/sign_in.dart';
import 'package:kaiteki/api/requests/misskey/timeline.dart';
import 'package:kaiteki/model/auth/account_compound.dart';
import 'package:kaiteki/model/auth/account_secret.dart';
import 'package:kaiteki/model/auth/authentication_data.dart';
import 'package:kaiteki/model/auth/client_secret.dart';
import 'package:kaiteki/model/auth/login_result.dart';
import 'package:kaiteki/model/fediverse/attachment.dart';
import 'package:kaiteki/model/fediverse/chat.dart';
import 'package:kaiteki/model/fediverse/chat_message.dart';
import 'package:kaiteki/model/fediverse/emoji.dart';
import 'package:kaiteki/model/fediverse/notification.dart';
import 'package:kaiteki/model/fediverse/post.dart';
import 'package:kaiteki/model/fediverse/reaction.dart';
import 'package:kaiteki/model/fediverse/timeline_type.dart';
import 'package:kaiteki/model/fediverse/user.dart';

part 'misskey_adapter.c.dart';

// TODO add missing implementations
class MisskeyAdapter extends FediverseAdapter<MisskeyClient>
    implements ChatSupport, ReactionSupport {
  MisskeyAdapter._(MisskeyClient client) : super(client);

  factory MisskeyAdapter({MisskeyClient client}) {
    return MisskeyAdapter._(client ?? MisskeyClient());
  }

  @override
  Future<User> getUser(String username, [String instance]) async {
    var mkUser = await client.showUserByName(username, instance);
    return toUser(mkUser);
  }

  @override
  Future<User> getUserById(String id) async {
    return toUser(await client.showUser(id));
  }

  @override
  Future<LoginResult> login(String instance, String username, String password,
      mfaCallback, AccountContainer accounts) async {
    client.instance = instance;

    var authResponse = await client.signIn(MisskeySignInRequest(
      username: username,
      password: password,
    ));

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
  Future<Post> postStatus(Post post, {Post parentPost}) {
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
  Future<Iterable<Post>> getTimeline(TimelineType type) async {
    Iterable<MisskeyNote> notes;

    var request = MisskeyTimelineRequest();
    switch (type) {
      case TimelineType.Home:
        notes = await client.getTimeline(request);
        break;
      default:
        return null;
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
  Future<void> addReaction(Post post, Emoji emoji) {
    throw UnimplementedError();
  }

  @override
  Future<void> removeReaction(Post post, Emoji emoji) {
    throw UnimplementedError();
  }
}
