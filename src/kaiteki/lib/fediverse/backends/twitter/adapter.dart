import 'package:kaiteki/account_manager.dart';
import 'package:kaiteki/auth/login_typedefs.dart';
import 'package:kaiteki/fediverse/adapter.dart';
import 'package:kaiteki/fediverse/api_type.dart';
import 'package:kaiteki/fediverse/backends/twitter/client.dart';
import 'package:kaiteki/fediverse/backends/twitter/keys.dart';
import 'package:kaiteki/fediverse/backends/twitter/model/entities/entities.dart'
    as twitter;
import 'package:kaiteki/fediverse/backends/twitter/model/entities/media.dart'
    as twitter;
import 'package:kaiteki/fediverse/backends/twitter/model/entities/media.dart';
import 'package:kaiteki/fediverse/backends/twitter/model/entities/url.dart';
import 'package:kaiteki/fediverse/backends/twitter/model/tweet.dart' as twitter;
import 'package:kaiteki/fediverse/backends/twitter/model/user.dart' as twitter;
import 'package:kaiteki/fediverse/model/attachment.dart';
import 'package:kaiteki/fediverse/model/emoji_category.dart';
import 'package:kaiteki/fediverse/model/instance.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/fediverse/model/post_draft.dart';
import 'package:kaiteki/fediverse/model/timeline_type.dart';
import 'package:kaiteki/fediverse/model/user.dart';
import 'package:kaiteki/fediverse/model/user_reference.dart';
import 'package:kaiteki/fediverse/model/visibility.dart';
import 'package:kaiteki/model/auth/account_compound.dart';
import 'package:kaiteki/model/auth/account_secret.dart';
import 'package:kaiteki/model/auth/authentication_data.dart';
import 'package:kaiteki/model/auth/client_secret.dart';
import 'package:kaiteki/model/auth/login_result.dart';
import 'package:kaiteki/model/file.dart';
import 'package:oauth1/oauth1.dart';

part 'adapter.c.dart';

class TwitterAdapter extends FediverseAdapter<TwitterClient> {
  factory TwitterAdapter({TwitterClient? client}) {
    return TwitterAdapter._(client ?? TwitterClient());
  }

  TwitterAdapter._(TwitterClient client) : super(client);

  @override
  Future<Post?> favoritePost(String id) {
    // TODO(Craftplacer): implement favoritePost, https://github.com/Kaiteki-Fedi/Kaiteki/issues/132
    throw UnimplementedError();
  }

  @override
  Future<Iterable<EmojiCategory>> getEmojis() async => [];

  @override
  Future<Instance> getInstance() async {
    return Instance(name: "Twitter", source: null, iconUrl: "https://");
  }

  @override
  Future<User> getMyself() async => toUser(await client.verifyCredentials());

  @override
  Future<Post> getPostById(String id) async {
    return toPost(await client.getTweet(id));
  }

  @override
  Future<Iterable<Post>> getStatusesOfUserById(String id) async {
    return (await client.getUserTimeline(userId: id)).map(toPost);
  }

  @override
  Future<Iterable<Post>> getThread(Post reply) {
    // TODO(Craftplacer): implement getThread, https://github.com/Kaiteki-Fedi/Kaiteki/issues/132
    throw UnimplementedError();
  }

  @override
  Future<Iterable<Post>> getTimeline(
    TimelineType type, {
    String? sinceId,
    String? untilId,
  }) async {
    switch (type) {
      case TimelineType.home:
        final homeTimeine = await client.getHomeTimeline(
          sinceId: sinceId,
          maxId: untilId,
        );
        return homeTimeine.map(toPost);
      default:
        throw UnimplementedError();
    }
  }

  @override
  Future<User> getUser(String username, [String? instance]) async {
    return toUser(await client.getUser(screenName: username));
  }

  @override
  Future<User> getUserById(String id) async {
    return toUser(await client.getUser(userId: id));
  }

  @override
  Future<LoginResult> login(
    String instance,
    String username,
    String password,
    MfaCallback requestMfa,
    OAuthCallback requestOAuth,
    AccountManager accounts,
  ) async {
    // client.authenticationData!.accessToken = token;

    twitter.User account;

    final platform = Platform(
      'https://api.twitter.com/oauth/request_token',
      'https://api.twitter.com/oauth/authorize',
      'https://api.twitter.com/oauth/access_token',
      SignatureMethods.hmacSha1,
    );
    final clientCredentials = ClientCredentials(token, secret);
    // create Authorization object with client credentials and platform definition

    // return auth.requestTokenCredentials(
    //  res.credentials,
    //  await requestMfa() ?? "",
    // );

    final auth = Authorization(clientCredentials, platform);
    late final AuthorizationResponse authResp;
    final resp = await requestOAuth((oAuthUrl) async {
      authResp = await auth.requestTemporaryCredentials(oAuthUrl.toString());
      final authUrl =
          auth.getResourceOwnerAuthorizationURI(authResp.credentials.token);
      return Uri.parse(authUrl);
    });

    var username = authResp.optionalParameters['screen_name'];

    client.authenticationData = TwitterAuthenticationData(
      authResp.credentials,
      clientCredentials,
    );

    try {
      account = await client.verifyCredentials();
      username ??= account.screenName;
    } catch (e) {
      return LoginResult.failed("Failed to verify credentials");
    }

    // Create and set account secret
    final accountSecret = AccountSecret("twitter.com", username, "");
    final compound = AccountCompound(
      container: accounts,
      adapter: this,
      account: toUser(account),
      clientSecret: ClientSecret(
        "twitter.com",
        username,
        "",
        apiType: ApiType.twitter,
      ),
      accountSecret: accountSecret,
    );
    await accounts.addCurrentAccount(compound);
    // request temporary credentials (request tokens)

    // await launch(
    //   "https://api.twitter.com/oauth/authorize"
    //   "?oauth_token=$accessToken"
    //   "&screen_name=$username",
    // );
    return LoginResult.successful();
  }

  @override
  Future<Post> postStatus(PostDraft draft, {Post? parentPost}) async {
    final tweet = await client.updateStatus(draft.content);
    return toPost(tweet);
  }

  @override
  Future<Instance?> probeInstance() async {
    if (client.instance == "twitter.com") {
      return Instance(name: "Twitter", source: null);
    }
    return null;
  }

  @override
  Future<Attachment> uploadAttachment(File file, String? description) {
    // TODO: implement uploadAttachment
    throw UnimplementedError();
  }

  @override
  Future<User?> followUser(String id) {
    // TODO: implement followUser
    throw UnimplementedError();
  }
}
