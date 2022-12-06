import 'package:kaiteki/fediverse/adapter.dart';
import 'package:kaiteki/fediverse/api_type.dart';
import 'package:kaiteki/fediverse/backends/twitter/v1/capabilities.dart';
import 'package:kaiteki/fediverse/backends/twitter/v1/client.dart';
import 'package:kaiteki/fediverse/backends/twitter/v1/keys.dart';
import 'package:kaiteki/fediverse/backends/twitter/v1/model/entities/entities.dart'
    as twitter;
import 'package:kaiteki/fediverse/backends/twitter/v1/model/entities/media.dart'
    as twitter;
import 'package:kaiteki/fediverse/backends/twitter/v1/model/entities/media.dart';
import 'package:kaiteki/fediverse/backends/twitter/v1/model/entities/url.dart';
import 'package:kaiteki/fediverse/backends/twitter/v1/model/media_upload.dart';
import 'package:kaiteki/fediverse/backends/twitter/v1/model/tweet.dart'
    as twitter;
import 'package:kaiteki/fediverse/backends/twitter/v1/model/user.dart'
    as twitter;
import 'package:kaiteki/fediverse/capabilities.dart';
import 'package:kaiteki/fediverse/model/model.dart';
import 'package:kaiteki/fediverse/model/post_metrics.dart';
import 'package:kaiteki/fediverse/model/timeline_query.dart';
import 'package:kaiteki/model/auth/account.dart';
import 'package:kaiteki/model/auth/account_key.dart';
import 'package:kaiteki/model/auth/login_result.dart';
import 'package:kaiteki/model/auth/secret.dart';
import 'package:kaiteki/model/file.dart';
import 'package:oauth1/oauth1.dart';
import 'package:tuple/tuple.dart';

part 'adapter.c.dart';

class OldTwitterAdapter extends CentralizedBackendAdapter {
  final OldTwitterClient client;

  factory OldTwitterAdapter() => OldTwitterAdapter.custom(OldTwitterClient());

  OldTwitterAdapter.custom(this.client);

  @override
  Future<User> getMyself() async => toUser(await client.verifyCredentials());

  @override
  Future<Post> getPostById(String id) async {
    return toPost(await client.getTweet(id));
  }

  @override
  Future<Iterable<Post>> getStatusesOfUserById(
    String id, {
    TimelineQuery? query,
  }) async {
    // TODO(Craftplacer): support timeline query
    return (await client.getUserTimeline(userId: id)).map(toPost);
  }

  @override
  Future<Iterable<Post>> getThread(Post reply) {
    // TODO(Craftplacer): implement getThread, https://github.com/Kaiteki-Fedi/Kaiteki/issues/132
    throw UnimplementedError();
  }

  @override
  Future<Iterable<Post>> getTimeline(
    TimelineKind type, {
    TimelineQuery? query,
  }) async {
    switch (type) {
      case TimelineKind.home:
        final homeTimeine = await client.getHomeTimeline(
          sinceId: query?.sinceId,
          maxId: query?.untilId,
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
    ClientSecret? clientSecret,
    requestCredentials,
    requestMfa,
    requestOAuth,
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

    final auth = Authorization(clientCredentials, platform);

    late final AuthorizationResponse tempResp;
    late final AuthorizationResponse authResp;

    const usePin = false;

    // ignore: dead_code
    if (usePin) {
      tempResp = await auth.requestTemporaryCredentials("oob");
      await requestMfa((code) async {
        authResp = await auth.requestTokenCredentials(
          tempResp.credentials,
          code,
        );
      });
    } else {
      final response = await requestOAuth((oAuthUrl) async {
        tempResp = await auth.requestTemporaryCredentials(oAuthUrl.toString());
        return Uri.parse(
          auth.getResourceOwnerAuthorizationURI(tempResp.credentials.token),
        );
      });

      if (response == null) return const LoginResult.aborted();

      authResp = await auth.requestTokenCredentials(
        tempResp.credentials,
        response["oauth_verifier"]!,
      );
    }

    client
      ..credentials = authResp.credentials
      ..clientCredentials = clientCredentials;

    var username = authResp.optionalParameters['screen_name'];
    try {
      account = await client.verifyCredentials();
      username ??= account.screenName;
    } catch (e, s) {
      return LoginResult.failed(Tuple2(e, s));
    }

    // Create and set account secret
    final ktkAccount = Account(
      adapter: this,
      user: toUser(account),
      key: AccountKey(
        ApiType.twitterV1,
        "twitter.com",
        username,
      ),
      // FIXME(Craftplacer): Make Twitter v1 restorable
      accountSecret: null,
      clientSecret: null,
    );

    return LoginResult.successful(ktkAccount);
  }

  @override
  Future<Post> postStatus(PostDraft draft, {Post? parentPost}) async {
    final tweet = await client.updateStatus(
      draft.content,
      mediaIds: draft.attachments.map((a) {
        return (a.source as MediaUpload).mediaIdString;
      }).toList(growable: false),
      replyToStatusId: draft.replyTo?.id,
    );
    return toPost(tweet);
  }

  @override
  Future<Attachment> uploadAttachment(File file, String? description) async {
    final upload = await client.uploadMedia(file);
    return Attachment(
      type: AttachmentType.image,
      source: upload,
      url: "", previewUrl: '', // TODO(Craftplacer): implement proper preview
    );
  }

  @override
  Future<User?> followUser(String id) {
    // TODO(Craftplacer): implement followUser
    throw UnimplementedError();
  }

  @override
  AdapterCapabilities get capabilities => const TwitterCapabilities();

  @override
  Future<List<User>> getRepeatees(String id) {
    // TODO(Craftplacer): implement getRepeatees
    throw UnimplementedError();
  }

  @override
  Future<bool> repeatPost(String id) {
    // TODO(Craftplacer): implement repeatPost
    throw UnimplementedError();
  }

  @override
  Future<bool> unrepeatPost(String id) {
    // TODO(Craftplacer): implement unrepeatPost
    throw UnimplementedError();
  }

  @override
  void applySecrets(
    ClientSecret? clientSecret,
    AccountSecret accountSecret,
  ) {
    // TODO(Craftplacer): implement applySecrets
    throw UnimplementedError();
  }

  @override
  Instance get instance => const Instance(name: "Twitter");
}
