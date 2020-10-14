import 'package:kaiteki/account_container.dart';
import 'package:kaiteki/adapters/fediverse_adapter.dart';
import 'package:kaiteki/adapters/interfaces/chat_support.dart';
import 'package:kaiteki/adapters/interfaces/reaction_support.dart';
import 'package:kaiteki/api/clients/pleroma_client.dart';
import 'package:kaiteki/api/model/mastodon/account.dart';
import 'package:kaiteki/api/model/mastodon/status.dart';
import 'package:kaiteki/api/model/pleroma/chat_message.dart';
import 'package:kaiteki/model/auth/account_secret.dart';
import 'package:kaiteki/model/auth/authentication_data.dart';
import 'package:kaiteki/model/auth/login_result.dart';
import 'package:kaiteki/model/fediverse/chat.dart';
import 'package:kaiteki/model/fediverse/chat_message.dart';
import 'package:kaiteki/model/fediverse/notification.dart';
import 'package:kaiteki/model/fediverse/post.dart';
import 'package:kaiteki/model/fediverse/reaction.dart';
import 'package:kaiteki/model/fediverse/timeline_type.dart';
import 'package:kaiteki/model/fediverse/user.dart';
import 'package:kaiteki/auth/login_functions.dart';
import 'package:kaiteki/model/auth/account_compound.dart';
import 'package:kaiteki/utils/string_extensions.dart';

part 'pleroma_adapter.c.dart'; // That file contains toEntity() methods

class PleromaAdapter extends FediverseAdapter<PleromaClient> implements ChatSupport, ReactionSupport {
  PleromaAdapter() : super(PleromaClient());


  @override
  Future<User> getUserById(String id) async {
    return toUser(await client.getAccount(id));
  }

  @override
  Future<LoginResult> login(String instance, String username, String password, mfaCallback, AccountContainer accounts) async {
    client.instance = instance;

    // Retrieve or create client secret
    var clientSecret = await LoginFunctions.getClientSecret(client, instance);
    client.authenticationData = MastodonAuthenticationData();
    client.authenticationData.clientSecret = clientSecret.clientSecret;
    client.authenticationData.clientId = clientSecret.clientId;

    String accessToken;

    // Try to login and handle error
    var loginResponse = await client.login(username, password);
    accessToken = loginResponse.accessToken;

    if (loginResponse.error.isNotNullOrEmpty) {
      if (loginResponse.error != "mfa_required") {
        return LoginResult.failed(loginResponse.error);
      }

      var code = await mfaCallback.call();

      if (code == null)
        return LoginResult.aborted();

      // TODO: add error-able TOTP screens
      // TODO: make use of a while loop to make this more efficient
      var mfaResponse = await client.respondMfa(
        loginResponse.mfaToken,
        int.parse(code),
      );

      if (mfaResponse.error.isNotNullOrEmpty) {
        return LoginResult.failed(mfaResponse.error);
      } else {
        accessToken = mfaResponse.accessToken;
      }
    }

    // Create and set account secret
    var accountSecret = new AccountSecret(instance, username, accessToken);
    client.authenticationData.accessToken = accountSecret.accessToken;

    // Check whether secrets work, and if we can get an account back
    var account = await client.verifyCredentials();
    if (account == null) {
      return LoginResult.failed("Failed to verify credentials");
    }

    var compound = AccountCompound(accounts, this, toUser(account), clientSecret, accountSecret);
    await accounts.addCurrentAccount(compound);

    return LoginResult.successful();
  }

  @override
  Future<Post> postStatus(Post post) {
    // TODO: implement postStatus
    throw UnimplementedError();
  }

  @override
  Future<User> getMyself() async {
    var account = await client.verifyCredentials();
    return toUser(account);
  }

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

  @override
  Future<Iterable<Notification>> getNotifications() {
    // TODO: implement getNotifications
    throw UnimplementedError();
  }

  @override
  Future<Iterable<Post>> getStatusesOfUserById(String id) async {
    return (await client.getStatuses(id)).map((mst) => toPost(mst));
  }

  @override
  Future<Iterable<Post>> getTimeline(TimelineType type) async {
    var posts = await client.getTimeline();
    return posts.map((m) => toPost(m));
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
  Future<Iterable<Reaction>> getReactions() {
    // TODO: implement getReactions
    throw UnimplementedError();
  }

  @override
  Future<void> react(Post post, Reaction reaction) {
    // TODO: implement react
    throw UnimplementedError();
  }
}