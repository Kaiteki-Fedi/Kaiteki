import 'package:fediverse_objects/mastodon.dart' as mastodon;
import 'package:fediverse_objects/pleroma.dart' as pleroma;
import 'package:kaiteki/account_manager.dart';
import 'package:kaiteki/auth/login_functions.dart';
import 'package:kaiteki/fediverse/api/adapters/fediverse_adapter.dart';
import 'package:kaiteki/fediverse/api/clients/mastodon_client.dart';
import 'package:kaiteki/fediverse/model/attachment.dart';
import 'package:kaiteki/fediverse/model/emoji.dart';
import 'package:kaiteki/fediverse/model/emoji_category.dart';
import 'package:kaiteki/fediverse/model/formatting.dart';
import 'package:kaiteki/fediverse/model/instance.dart';
import 'package:kaiteki/fediverse/model/notification.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/fediverse/model/post_draft.dart';
import 'package:kaiteki/fediverse/model/reaction.dart';
import 'package:kaiteki/fediverse/model/timeline_type.dart';
import 'package:kaiteki/fediverse/model/user.dart';
import 'package:kaiteki/fediverse/model/user_reference.dart';
import 'package:kaiteki/fediverse/model/visibility.dart';
import 'package:kaiteki/model/auth/account_compound.dart';
import 'package:kaiteki/model/auth/account_secret.dart';
import 'package:kaiteki/model/auth/authentication_data.dart';
import 'package:kaiteki/model/auth/login_result.dart';
import 'package:kaiteki/utils/extensions/iterable.dart';
import 'package:kaiteki/utils/extensions/string.dart';

part 'shared_adapter.c.dart'; // That file contains toEntity() methods

/// A class that allows Mastodon-derivatives (e.g. Pleroma and Mastodon itself)
/// to use pre-existing code.
class SharedMastodonAdapter<T extends MastodonClient>
    extends FediverseAdapter<T> {
  SharedMastodonAdapter(T client) : super(client);

  @override
  Future<User> getUserById(String id) async {
    return toUser(await client.getAccount(id));
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

    // Retrieve or create client secret
    final clientSecret = await LoginFunctions.getClientSecret(
      client,
      instance,
      accounts.getClientRepo(),
    );

    client.authenticationData = MastodonAuthenticationData(
      clientSecret.clientId,
      clientSecret.clientSecret,
    );

    String accessToken;

    // Try to login and handle error
    final loginResponse = await client.login(username, password);

    if (loginResponse.error.isNotNullOrEmpty) {
      if (loginResponse.error != "mfa_required") {
        return LoginResult.failed(loginResponse.error);
      }

      final code = await mfaCallback.call();

      if (code == null) {
        return LoginResult.aborted();
      }

      // TODO(Craftplacer): add error-able TOTP screens
      // TODO(Craftplacer): make use of a while loop to make this more efficient
      final mfaResponse = await client.respondMfa(
        loginResponse.mfaToken!,
        int.parse(code),
      );

      if (mfaResponse.error.isNotNullOrEmpty) {
        return LoginResult.failed(mfaResponse.error);
      } else {
        accessToken = mfaResponse.accessToken!;
      }
    } else {
      accessToken = loginResponse.accessToken!;
    }

    // Create and set account secret
    final accountSecret = AccountSecret(instance, username, accessToken);
    client.authenticationData!.accessToken = accountSecret.accessToken;

    // Check whether secrets work, and if we can get an account back
    mastodon.Account account;

    try {
      account = await client.verifyCredentials();
    } catch (e) {
      return LoginResult.failed("Failed to verify credentials");
    }

    final compound = AccountCompound(
      container: accounts,
      adapter: this,
      account: toUser(account),
      clientSecret: clientSecret,
      accountSecret: accountSecret,
    );
    await accounts.addCurrentAccount(compound);

    return LoginResult.successful();
  }

  @override
  Future<Post> postStatus(PostDraft draft, {Post? parentPost}) async {
    String visibility;

    switch (draft.visibility) {
      case Visibility.public:
        visibility = "public";
        break;
      case Visibility.unlisted:
        visibility = "unlisted";
        break;
      case Visibility.followersOnly:
        visibility = "private";
        break;
      case Visibility.direct:
        visibility = "direct";
        break;
    }

    final contentType = getContentType(draft.formatting);

    final newPost = await client.postStatus(
      draft.content,
      pleromaPreview: false,
      visibility: visibility,
      spoilerText: draft.subject,
      inReplyToId: draft.replyTo?.id,
      contentType: contentType,
    );
    return toPost(newPost);
  }

  String getContentType(Formatting formatting) {
    const formattingToMimeType = {
      Formatting.plainText: "text/plain",
      Formatting.markdown: "text/markdown",
      Formatting.html: "text/html",
      Formatting.bbCode: "text/bbcode",
    };

    return formattingToMimeType[formatting]!;
  }

  @override
  Future<User> getMyself() async {
    final account = await client.verifyCredentials();
    return toUser(account);
  }

  @override
  Future<Iterable<Notification>> getNotifications() {
    // TODO(Craftplacer): implement getNotifications
    throw UnimplementedError();
  }

  @override
  Future<Iterable<Post>> getStatusesOfUserById(String id) async {
    return (await client.getStatuses(id)).map(toPost);
  }

  @override
  Future<Iterable<Post>> getTimeline(
    TimelineType type, {
    String? sinceId,
    String? untilId,
  }) async {
    final posts = await client.getTimeline(minId: sinceId, maxId: untilId);
    return posts.map(toPost);
  }

  @override
  Future<User> getUser(String username, [String? instance]) {
    // TODO(Craftplacer): implement getUser
    throw UnimplementedError();
  }

  @override
  Future<Iterable<EmojiCategory>> getEmojis() async {
    final emojis = await client.getCustomEmojis();
    final categories = emojis.groupBy((emoji) => emoji.category);

    return categories.entries.map((kv) {
      return EmojiCategory(kv.key, kv.value.map(toEmoji));
    });
  }

  @override
  Future<Iterable<Post>> getThread(Post reply) async {
    final status = reply.source as mastodon.Status;
    final context = await client.getStatusContext(status.id);
    return <Post>[
      ...context.ancestors.map(toPost),
      reply,
      ...context.descendants.map(toPost),
    ];
  }

  @override
  Future<Instance> getInstance() {
    throw UnimplementedError();
  }

  @override
  Future<Instance?> probeInstance() {
    throw UnimplementedError();
  }

  @override
  Future<Post> getPostById(String id) async {
    final status = await client.getStatus(id);
    return toPost(status);
  }

  @override
  Future<Post?> favoritePost(String id) async {
    return toPost(await client.favouriteStatus(id));
  }

  @override
  Future<User?> followUser(String id) {
    // TODO(Craftplacer): implement followUser
    throw UnimplementedError();
  }
}
