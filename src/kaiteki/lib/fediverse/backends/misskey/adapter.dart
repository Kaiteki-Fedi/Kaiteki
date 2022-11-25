import 'package:crypto/crypto.dart';
import 'package:fediverse_objects/misskey.dart' as misskey;
// FIXME(Craftplacer): Fix exports for Misskey notifications
// ignore: implementation_imports
import 'package:fediverse_objects/src/misskey/notification.dart' as misskey;
import 'package:intl/intl.dart';
import 'package:kaiteki/auth/login_typedefs.dart';
import 'package:kaiteki/constants.dart' as consts;
import 'package:kaiteki/exceptions/authentication_exception.dart';
import 'package:kaiteki/fediverse/adapter.dart';
import 'package:kaiteki/fediverse/api_type.dart';
import 'package:kaiteki/fediverse/backends/misskey/capabilties.dart';
import 'package:kaiteki/fediverse/backends/misskey/client.dart';
import 'package:kaiteki/fediverse/backends/misskey/exception.dart';
import 'package:kaiteki/fediverse/backends/misskey/requests/sign_in.dart';
import 'package:kaiteki/fediverse/backends/misskey/requests/timeline.dart';
import 'package:kaiteki/fediverse/backends/misskey/responses/check_session.dart';
import 'package:kaiteki/fediverse/backends/misskey/responses/signin.dart';
import 'package:kaiteki/fediverse/interfaces/chat_support.dart';
import 'package:kaiteki/fediverse/interfaces/custom_emoji_support.dart';
import 'package:kaiteki/fediverse/interfaces/notification_support.dart';
import 'package:kaiteki/fediverse/interfaces/reaction_support.dart';
import 'package:kaiteki/fediverse/model/model.dart';
import 'package:kaiteki/fediverse/model/notification.dart';
import 'package:kaiteki/fediverse/model/timeline_query.dart';
import 'package:kaiteki/logger.dart';
import 'package:kaiteki/model/account_key.dart';
import 'package:kaiteki/model/auth/account_compound.dart';
import 'package:kaiteki/model/auth/account_secret.dart';
import 'package:kaiteki/model/auth/authentication_data.dart';
import 'package:kaiteki/model/auth/client_secret.dart';
import 'package:kaiteki/model/auth/login_result.dart';
import 'package:kaiteki/model/file.dart';
import 'package:kaiteki/utils/extensions/iterable.dart';
import 'package:tuple/tuple.dart';
import 'package:uuid/uuid.dart';

part 'adapter.c.dart';

final _logger = getLogger('MisskeyAdapter');

// TODO(Craftplacer): add missing implementations
class MisskeyAdapter extends FediverseAdapter<MisskeyClient>
    implements
        ChatSupport,
        ReactionSupport,
        CustomEmojiSupport,
        NotificationSupport {
  factory MisskeyAdapter(String instance) {
    return MisskeyAdapter.custom(MisskeyClient(instance));
  }

  MisskeyAdapter.custom(super.client);

  @override
  Future<User> getUser(String username, [String? instance]) async {
    final mkUser = await client.showUserByName(username, instance);
    return toUser(mkUser, client.instance);
  }

  @override
  Future<User> getUserById(String id) async {
    return toUser((await client.showUser(id))!, client.instance);
  }

  Future<MisskeyCheckSessionResponse?> loginMiAuth(
    String session,
    OAuthCallback requestOAuth,
  ) async {
    final result = await requestOAuth((oauthUrl) async {
      return Uri.https(instance, "/miauth/$session", {
        "name": consts.appName,
        "icon": consts.appRemoteIcon,
        "callback": oauthUrl.toString(),
        "permission": consts.defaultMisskeyPermissions.join(","),
      });
    });

    if (result == null) return null;

    return client.checkSession(session);
  }

  Future<Tuple2<misskey.User, String>?> loginAlt(
    OAuthCallback requestOAuth,
  ) async {
    late final String appSecret, sessionToken;
    final result = await requestOAuth((oauthUrl) async {
      final app = await client.createApp(
        consts.appName,
        consts.appDescription,
        consts.defaultMisskeyPermissions,
        callbackUrl: oauthUrl.toString(),
      );

      appSecret = app.secret;

      final session = await client.generateSession(app.secret);
      sessionToken = session.token;

      return Uri.parse(session.url);
    });

    if (result == null) return null;

    final userkeyResponse = await client.userkey(appSecret, sessionToken);
    final concat = userkeyResponse.accessToken + appSecret;
    return Tuple2(
      userkeyResponse.user!,
      sha256.convert(concat.codeUnits).toString(),
    );
  }

  Future<MisskeySignInResponse> loginPrivate(
    String username,
    String password,
  ) async {
    return client.signIn(
      MisskeySignInRequest(username: username, password: password),
    );
  }

  Future<Tuple3<String, String?, misskey.User?>?> authenticate(
    CredentialsCallback requestCredentials,
    OAuthCallback requestOAuth,
  ) async {
    try {
      final tuple = await loginAlt(requestOAuth);
      if (tuple == null) return null;
      return Tuple3(tuple.item2, null, tuple.item1);
    } catch (e, s) {
      _logger.w(
        "Failed to login using the conventional method. Trying MiAuth instead...",
        e,
        s,
      );
    }

    try {
      final session = const Uuid().v4();
      final response = await loginMiAuth(session, requestOAuth);
      if (response == null) return null;
      return Tuple3(response.token, null, response.user);
    } catch (e, s) {
      _logger.w(
        "Failed to login using MiAuth. Trying private endpoints instead...",
        e,
        s,
      );
    }

    final signInResponse = await requestCredentials(
      (creds) async {
        if (creds == null) return null;

        final signInResponse = await loginPrivate(
          creds.username,
          creds.password,
        );

        return signInResponse;
      },
    );

    if (signInResponse == null) return null;

    return Tuple3(signInResponse.i, signInResponse.id, null);
  }

  @override
  Future<LoginResult> login(
    ClientSecret? clientSecret,
    requestCredentials,
    requestMfa,
    requestOAuth,
  ) async {
    final credentials = await authenticate(requestCredentials, requestOAuth);

    if (credentials == null) return const LoginResult.aborted();

    // Create and set account secret
    final accountSecret = AccountSecret(credentials.item1);
    client.authenticationData = MisskeyAuthenticationData(credentials.item1);

    // Check whether secrets work, and if we can get an account back
    assert(
      !(credentials.item3 == null && credentials.item2 == null),
      "Both user and id are null",
    );
    final user = credentials.item3 ?? await client.showUser(credentials.item2!);

    if (user == null) {
      return const LoginResult.failed(
        Tuple2(AuthenticationException("Failed to retrieve user info"), null),
      );
    }

    final account = Account(
      adapter: this,
      user: toUser(user, client.instance),
      key: AccountKey(ApiType.misskey, instance, user.username),
      clientSecret: null,
      accountSecret: accountSecret,
    );

    return LoginResult.successful(account);
  }

  @override
  Future<Post> postStatus(PostDraft draft, {Post? parentPost}) async {
    final visibility = <Visibility, String>{
      Visibility.direct: "specified",
      Visibility.followersOnly: "followers",
      Visibility.unlisted: "home",
      Visibility.public: "public",
    }[draft.visibility]!;

    final note = await client.createNote(
      visibility,
      text: draft.content,
      cw: draft.subject,
      replyId: draft.replyTo?.id,
      fileIds: draft.attachments.map((a) {
        return (a.source as misskey.DriveFile).id;
      }).toList(),
    );

    return toPost(note, client.instance);
  }

  @override
  Future<User> getMyself() async {
    return toUser(await client.i(), client.instance);
  }

  @override
  Future<Iterable<Chat>> getChats() {
    throw UnimplementedError();
  }

  @override
  Future<Iterable<Post>> getTimeline(
    TimelineKind type, {
    TimelineQuery<String>? query,
  }) async {
    Iterable<misskey.Note> notes;

    final request = MisskeyTimelineRequest(
      sinceId: query?.sinceId,
      untilId: query?.untilId,
    );

    switch (type) {
      case TimelineKind.home:
        notes = await client.getTimeline(request);
        break;

      // ignore: no_default_cases
      default:
        throw UnimplementedError(
          "Fetching of timeline type $type is not implemented yet.",
        );
    }

    return notes.map((n) => toPost(n, client.instance));
  }

  @override
  Future<Iterable<ChatMessage>> getChatMessages(Chat chat) {
    throw UnimplementedError();
  }

  @override
  Future<Iterable<Post>> getStatusesOfUserById(
    String id, {
    TimelineQuery<String>? query,
  }) async {
    final notes = await client.showUserNotes(
      id,
      excludeNsfw: false,
      fileTypes: [
        "image/jpeg",
        "image/png",
        "image/gif",
        "image/apng",
        "image/vnd.mozilla.apng"
      ],
      sinceId: query?.sinceId,
      untilId: query?.untilId,
    );
    return notes.map((n) => toPost(n, client.instance));
  }

  @override
  Future<ChatMessage> postChatMessage(Chat chat, ChatMessage message) {
    throw UnimplementedError();
  }

  @override
  Future<void> addReaction(Post post, Emoji emoji) async {
    String emojiName;

    if (emoji is CustomEmoji) {
      emojiName = ':${emoji.short}:';
    } else if (emoji is UnicodeEmoji) {
      emojiName = emoji.emoji;
    } else {
      throw UnimplementedError(
        "Emoji type ${emoji.runtimeType} is not supported yet.",
      );
    }

    await client.createReaction(post.id, emojiName);
  }

  @override
  Future<void> removeReaction(Post post, Emoji emoji) async {
    // The "emoji" parameter is ignored, because in Misskey you can only react
    // once.
    try {
      await client.deleteReaction(post.id);
    } on MisskeyException catch (e) {
      if (e.code != "NOT_REACTED") rethrow;
    }
  }

  @override
  Future<List<EmojiCategory>> getEmojis() async {
    final instanceMeta = await client.getInstanceMeta();
    final emojiCategories = instanceMeta.emojis.groupBy((e) => e.category);
    return emojiCategories.entries
        .map(
          (kv) => EmojiCategory(
            kv.key,
            kv.value.map(toEmoji).map(EmojiCategoryItem.new).toList(),
          ),
        )
        .toList(growable: false);
  }

  @override
  Future<Iterable<Post>> getThread(Post reply) async {
    final notes = await client.getConversation(reply.id);
    return notes.map((n) => toPost(n, client.instance)).followedBy([reply]);
  }

  @override
  Future<Instance> getInstance() async {
    return toInstance(await client.getInstanceMeta(), client.baseUrl);
  }

  @override
  Future<Instance> probeInstance() async {
    return getInstance();
  }

  @override
  Future<User?> followUser(String id) {
    // TODO(Craftplacer): implement followUser
    throw UnimplementedError();
  }

  @override
  Future<Post> getPostById(String id) {
    // TODO(Craftplacer): implement getPostById
    throw UnimplementedError();
  }

  @override
  Future<Attachment> uploadAttachment(File file, String? description) async {
    final driveFile = await client.createDriveFile(
      await file.toMultipartFile("file"),
    );
    return toAttachment(driveFile);
  }

  @override
  MisskeyCapabilities get capabilities => const MisskeyCapabilities();

  @override
  Future<void> repeatPost(String id) async => client.createRenote(id);

  @override
  Future<void> unrepeatPost(String id) => throw UnimplementedError();

  @override
  Future<List<User>> getRepeatees(String id) async {
    final notes = await client.getRenotes(id);
    return notes
        .map((n) => n.user)
        .map((u) => toUserFromLite(u, client.instance))
        .toList();
  }

  @override
  Future<void> clearAllNotifications() =>
      throw UnsupportedError("Misskey does not support clearing notifications");

  @override
  Future<List<Notification>> getNotifications() async {
    final notifications = await client.getNotifications();
    return notifications
        .map((n) => toNotification(n, client.instance))
        .toList();
  }

  @override
  Future<void> markAllNotificationsAsRead() =>
      client.markAllNotificationsAsRead();

  @override
  Future<void> markNotificationAsRead(Notification notification) {
    throw UnsupportedError(
      "Misskey does not support marking individual notifications as read",
    );
  }
}
