import 'package:kaiteki_core/src/social/backends/twitter/v1/capabilities.dart';
import 'package:kaiteki_core/src/social/backends/twitter/v1/client.dart';
import 'package:kaiteki_core/src/social/backends/twitter/v1/keys.dart';
import 'package:kaiteki_core/social.dart';
import 'package:oauth1/oauth1.dart';

import 'extensions.dart';
import 'model/media_upload.dart';
import 'model/user.dart' as twitter;

class OldTwitterAdapter extends CentralizedBackendAdapter
    implements LoginSupport {
  final OldTwitterClient client;

  factory OldTwitterAdapter() => OldTwitterAdapter.custom(OldTwitterClient());

  OldTwitterAdapter.custom(this.client);

  @override
  ApiType get type => ApiType.twitterV1;

  @override
  Future<User> getMyself() async {
    final user = await client.verifyCredentials();
    return user.toKaiteki();
  }

  @override
  Future<Post> getPostById(String id) async {
    final tweet = await client.getTweet(id);
    return tweet.toKaiteki();
  }

  @override
  Future<List<Post>> getStatusesOfUserById(
    String id, {
    TimelineQuery? query,
  }) async {
    // TODO(Craftplacer): support timeline query
    final tweets = await client.getUserTimeline(userId: id);
    return tweets.map((e) => e.toKaiteki()).toList();
  }

  @override
  Future<Iterable<Post>> getThread(Post reply) {
    // TODO(Craftplacer): implement getThread, https://github.com/Kaiteki-Fedi/Kaiteki/issues/132
    throw UnimplementedError();
  }

  @override
  Future<List<Post>> getTimeline(
    TimelineKind type, {
    TimelineQuery? query,
  }) async {
    switch (type) {
      case TimelineKind.home:
        final timeline = await client.getHomeTimeline(
          sinceId: query?.sinceId as String?,
          maxId: query?.untilId as String?,
        );
        return timeline.map((e) => e.toKaiteki()).toList();

      default:
        throw UnsupportedError('$type is not supported by Twitter');
    }
  }

  @override
  Future<User> getUser(String username, [String? instance]) async {
    final user = await client.getUser(screenName: username);
    return user.toKaiteki();
  }

  @override
  Future<User> getUserById(String id) async {
    final user = await client.getUser(userId: id);
    return user.toKaiteki();
  }

  @override
  Future<LoginResult> login(LoginContext context) async {
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

    final requestOAuth = context.requestOAuth;
    if (requestOAuth == null) {
      tempResp = await auth.requestTemporaryCredentials('oob');
      await context.requestCode(
        const CodePromptOptions.numericOnly(8),
        (code) async {
          authResp = await auth.requestTokenCredentials(
            tempResp.credentials,
            code,
          );
        },
      );
    } else {
      final response = await requestOAuth((oAuthUrl) async {
        tempResp = await auth.requestTemporaryCredentials(oAuthUrl.toString());
        return Uri.parse(
          auth.getResourceOwnerAuthorizationURI(tempResp.credentials.token),
        );
      });

      if (response == null) return const LoginAborted();

      authResp = await auth.requestTokenCredentials(
        tempResp.credentials,
        response['oauth_verifier']!,
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
      return LoginFailure((e, s));
    }

    // Create and set account secret
    return LoginSuccess(
      user: account.toKaiteki(),
      // FIXME(Craftplacer): Make Twitter v1 restorable
      userSecret: null,
      clientSecret: null,
    );
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
    return tweet.toKaiteki();
  }

  @override
  Future<Attachment> uploadAttachment(AttachmentDraft draft) async {
    throw UnimplementedError();

    // TODO(Craftplacer): implement proper preview
    // final upload = await client.uploadMedia(draft.file!);
    // return Attachment(
    //   type: AttachmentType.image,
    //   source: upload,
    //   url: "", previewUrl: "",
    // );
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
    UserSecret userSecret,
  ) {
    // TODO(Craftplacer): implement applySecrets
    throw UnimplementedError();
  }

  @override
  Instance get instance => const Instance(name: 'Twitter');

  @override
  Future<PaginatedList<String?, User>> getFollowers(
    String userId, {
    String? sinceId,
    String? untilId,
  }) =>
      throw UnimplementedError();

  @override
  Future<PaginatedList<String?, User>> getFollowing(
    String userId, {
    String? sinceId,
    String? untilId,
  }) =>
      throw UnimplementedError();

  @override
  Future<void> deleteAccount(String password) => throw UnimplementedError();

  @override
  Future<User> lookupUser(String username, [String? host]) =>
      throw UnimplementedError();

  @override
  Future<User?> unfollowUser(String id) => throw UnimplementedError();
}
