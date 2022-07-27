import 'package:fediverse_objects/mastodon.dart' as mastodon;
import 'package:fediverse_objects/pleroma.dart' as pleroma;
import 'package:kaiteki/constants.dart' as consts;
import 'package:kaiteki/exceptions/authentication_exception.dart';
import 'package:kaiteki/fediverse/adapter.dart';
import 'package:kaiteki/fediverse/backends/mastodon/capabilities.dart';
import 'package:kaiteki/fediverse/backends/mastodon/client.dart';
import 'package:kaiteki/fediverse/interfaces/bookmark_support.dart';
import 'package:kaiteki/fediverse/interfaces/custom_emoji_support.dart';
import 'package:kaiteki/fediverse/interfaces/favorite_support.dart';
import 'package:kaiteki/fediverse/model/model.dart';
// ignore: unnecessary_import, Dart Analyzer is fucking with me
import 'package:kaiteki/fediverse/model/timeline_kind.dart';
import 'package:kaiteki/model/account_key.dart';
import 'package:kaiteki/model/auth/account_compound.dart';
import 'package:kaiteki/model/auth/account_secret.dart';
import 'package:kaiteki/model/auth/authentication_data.dart';
import 'package:kaiteki/model/auth/client_secret.dart';
import 'package:kaiteki/model/auth/login_result.dart';
import 'package:kaiteki/model/file.dart';
import 'package:kaiteki/utils/extensions/iterable.dart';
import 'package:kaiteki/utils/extensions/string.dart';
import 'package:tuple/tuple.dart';

part 'shared_adapter.c.dart'; // That file contains toEntity() methods

/// A class that allows Mastodon-derivatives (e.g. Pleroma and Mastodon itself)
/// to use pre-existing code.
abstract class SharedMastodonAdapter<T extends MastodonClient>
    extends FediverseAdapter<T>
    implements CustomEmojiSupport, FavoriteSupport, BookmarkSupport {
  SharedMastodonAdapter(super.client);

  @override
  Future<User> getUserById(String id) async {
    return toUser(await client.getAccount(id));
  }

  Future<ClientSecret> _makeClientSecret(
    String instance, [
    String? redirectUri,
  ]) async {
    // _logger.v("Creating new application on $instance");

    final application = await client.createApplication(
      instance,
      consts.appName,
      consts.appWebsite,
      redirectUri ?? "urn:ietf:wg:oauth:2.0:oob",
      consts.defaultScopes,
    );

    final clientSecret = ClientSecret(
      application.clientId!,
      application.clientSecret!,
    );

    client.authenticationData = MastodonAuthenticationData(
      clientSecret.clientId,
      clientSecret.clientSecret,
    );

    return clientSecret;
  }

  @override
  Future<LoginResult> login(
    ClientSecret? clientSecret,
    String username,
    String password,
    requestMfa,
    requestOAuth,
  ) async {
    late final ClientSecret clientSecret;
    late final String accessToken;

    if (consts.useOAuth) {
      // if (Platform.isAndroid | Platform.isIOS) {}
      final scopes = consts.defaultScopes.join(" ");
      late final String url;
      final response = await requestOAuth((oauthUrl) async {
        clientSecret = await _makeClientSecret(
          instance,
          url = oauthUrl.toString(),
        );

        return Uri.https(instance, "/oauth/authorize", {
          "response_type": "code",
          "client_id": clientSecret.clientId,
          "redirect_uri": url,
          "scope": scopes,
        });
      });

      if (response == null) return const LoginResult.aborted();

      final code = response["code"]!;
      final loginResponse = await client.getToken(
        "authorization_code",
        clientSecret.clientId,
        clientSecret.clientSecret,
        url,
        code: code,
        scope: scopes,
      );

      accessToken = loginResponse.accessToken!;
    } else {
      clientSecret = await _makeClientSecret(instance);

      final loginResponse = await client.login(username, password);

      if (loginResponse.error.isNotNullOrEmpty) {
        if (loginResponse.error != "mfa_required") {
          return LoginResult.failed(
            Tuple2(AuthenticationException(loginResponse.error!), null),
          );
        }

        final code = await requestMfa.call();

        if (code == null) {
          return const LoginResult.aborted();
        }

        // TODO(Craftplacer): add error-able TOTP screens
        // TODO(Craftplacer): make use of a while loop to make this more efficient
        final mfaResponse = await client.respondMfa(
          loginResponse.mfaToken!,
          int.parse(code),
        );

        if (mfaResponse.error.isNotNullOrEmpty) {
          return LoginResult.failed(
            Tuple2(AuthenticationException(mfaResponse.error!), null),
          );
        } else {
          accessToken = mfaResponse.accessToken!;
        }
      } else {
        accessToken = loginResponse.accessToken!;
      }
    }

    // Create and set account secret
    final accountSecret = AccountSecret(accessToken);
    client.authenticationData!.accessToken = accountSecret.accessToken;

    // Check whether secrets work, and if we can get an account back
    mastodon.Account account;

    try {
      account = await client.verifyCredentials();
    } catch (e) {
      return const LoginResult.failed(
        Tuple2(AuthenticationException("Failed to verify credentials"), null),
      );
    }

    final ktkAccount = Account(
      adapter: this,
      user: toUser(account),
      clientSecret: clientSecret,
      accountSecret: accountSecret,
      key: AccountKey(
        client.type,
        instance,
        username,
      ),
    );

    return LoginResult.successful(ktkAccount);
  }

  @override
  Future<Post> postStatus(PostDraft draft, {Post? parentPost}) async {
    final visibility = const <Visibility, String>{
      Visibility.public: "public",
      Visibility.unlisted: "unlisted",
      Visibility.followersOnly: "private",
      Visibility.direct: "direct"
    }[draft.visibility]!;

    final contentType = getContentType(draft.formatting);

    final newPost = await client.postStatus(
      draft.content,
      pleromaPreview: false,
      visibility: visibility,
      spoilerText: draft.subject,
      inReplyToId: draft.replyTo?.id,
      contentType: contentType,
      mediaIds: draft.attachments
          .map((a) => (a.source as mastodon.Attachment).id)
          .toList(),
    );
    return toPost(newPost);
  }

  String? getContentType(Formatting? formatting) {
    const formattingToMimeType = {
      Formatting.plainText: "text/plain",
      Formatting.markdown: "text/markdown",
      Formatting.html: "text/html",
      Formatting.bbCode: "text/bbcode",
    };

    return formattingToMimeType[formatting];
  }

  @override
  Future<User> getMyself() async {
    final account = await client.verifyCredentials();
    return toUser(account);
  }

  @override
  Future<Iterable<Post>> getStatusesOfUserById(String id) async {
    return (await client.getStatuses(id)).map(toPost);
  }

  @override
  Future<Iterable<Post>> getTimeline(
    TimelineKind type, {
    String? sinceId,
    String? untilId,
  }) async {
    final Iterable<mastodon.Status> posts;

    switch (type) {
      case TimelineKind.home:
        posts = await client.getHomeTimeline(minId: sinceId, maxId: untilId);
        break;

      case TimelineKind.local:
        posts = await client.getPublicTimeline(
          minId: sinceId,
          maxId: untilId,
          local: true,
        );
        break;

      case TimelineKind.federated:
        posts = await client.getPublicTimeline(
          minId: sinceId,
          maxId: untilId,
        );
        break;

      default:
        throw UnimplementedError();
    }

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
  Future<Instance> getInstance() => throw UnimplementedError();

  @override
  Future<Instance?> probeInstance() => throw UnimplementedError();

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

  @override
  Future<Attachment> uploadAttachment(File file, String? description) async {
    final attachment = await client.uploadMedia(file, description);
    return toAttachment(attachment);
  }

  @override
  MastodonCapabilities get capabilities => const MastodonCapabilities();

  @override
  Future<Post?> repeatPost(String id) async {
    final status = await client.reblogStatus(id);
    return toPost(status);
  }

  @override
  Future<Post?> unfavoritePost(String id) async {
    final status = await client.unfavouriteStatus(id);
    return toPost(status);
  }

  @override
  Future<Post?> unrepeatPost(String id) async {
    final status = await client.unreblogStatus(id);
    return toPost(status);
  }

  @override
  Future<Post?> bookmarkPost(String id) async {
    final status = await client.bookmarkStatus(id);
    return toPost(status);
  }

  @override
  Future<List<Post>> getBookmarks({
    String? maxId,
    String? sinceId,
    String? minId,
  }) async {
    final statuses = await client.getBookmarkedStatuses(
      maxId: maxId,
      sinceId: sinceId,
      minId: minId,
    );
    return statuses.map(toPost).toList();
  }

  @override
  Future<Post?> unbookmarkPost(String id) async {
    final status = await client.unbookmarkStatus(id);
    return toPost(status);
  }

  @override
  Future<List<User>> getFavoritees(String id) async {
    final users = await client.getFavouritedBy(id);
    return users.map(toUser).toList();
  }

  @override
  Future<List<User>> getRepeatees(String id) async {
    final users = await client.getBoostedBy(id);
    return users.map(toUser).toList();
  }
}
