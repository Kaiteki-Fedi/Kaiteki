import 'package:crypto/crypto.dart';
import 'package:fediverse_objects/misskey.dart' as misskey;
import 'package:intl/intl.dart';
import 'package:kaiteki/auth/login_typedefs.dart';
import 'package:kaiteki/constants.dart' as consts;
import 'package:kaiteki/exceptions/authentication_exception.dart';
import 'package:kaiteki/fediverse/adapter.dart';
import 'package:kaiteki/fediverse/api_type.dart';
import 'package:kaiteki/fediverse/backends/misskey/capabilties.dart';
import 'package:kaiteki/fediverse/backends/misskey/client.dart';
import 'package:kaiteki/fediverse/backends/misskey/requests/sign_in.dart';
import 'package:kaiteki/fediverse/backends/misskey/requests/timeline.dart';
import 'package:kaiteki/fediverse/backends/misskey/responses/check_session.dart';
import 'package:kaiteki/fediverse/backends/misskey/responses/signin.dart';
import 'package:kaiteki/fediverse/interfaces/chat_support.dart';
import 'package:kaiteki/fediverse/interfaces/custom_emoji_support.dart';
import 'package:kaiteki/fediverse/interfaces/reaction_support.dart';
import 'package:kaiteki/fediverse/model/model.dart';
import 'package:kaiteki/logger.dart';
import 'package:kaiteki/model/account_key.dart';
import 'package:kaiteki/model/auth/account_compound.dart';
import 'package:kaiteki/model/auth/account_secret.dart';
import 'package:kaiteki/model/auth/authentication_data.dart';
import 'package:kaiteki/model/auth/client_secret.dart';
import 'package:kaiteki/model/auth/login_result.dart';
import 'package:kaiteki/model/file.dart';
import 'package:kaiteki/utils/extensions/iterable.dart';
import 'package:logger/logger.dart';
import 'package:tuple/tuple.dart';
import 'package:uuid/uuid.dart';

part 'adapter.c.dart';

final _logger = getLogger('MisskeyAdapter');

// TODO(Craftplacer): add missing implementations
class MisskeyAdapter extends FediverseAdapter<MisskeyClient>
    implements ChatSupport, ReactionSupport, CustomEmojiSupport {
  factory MisskeyAdapter(String instance) {
    return MisskeyAdapter.custom(MisskeyClient(instance));
  }

  MisskeyAdapter.custom(super.client);

  @override
  Future<User> getUser(String username, [String? instance]) async {
    final mkUser = await client.showUserByName(username, instance);
    return toUser(mkUser);
  }

  @override
  Future<User> getUserById(String id) async {
    return toUser((await client.showUser(id))!);
  }

  Future<MisskeyCheckSessionResponse> loginMiAuth(
    String session,
    OAuthCallback requestOAuth,
  ) async {
    await requestOAuth((oauthUrl) async {
      return Uri.https(instance, "/miauth/$session", {
        "name": consts.appName,
        "icon": consts.appRemoteIcon,
        "callback": oauthUrl.toString(),
        "permission": consts.defaultMisskeyPermissions.join(","),
      });
    });

    return client.checkSession(session);
  }

  Future<Tuple2<misskey.User, String>> loginAlt(
    OAuthCallback requestOAuth,
  ) async {
    late final String appSecret, sessionToken;
    await requestOAuth((oauthUrl) async {
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

  @override
  Future<LoginResult> login(
    ClientSecret? clientSecret,
    String username,
    String password,
    requestMfa,
    requestOAuth,
  ) async {
    final session = const Uuid().v4();
    late final String token;
    late final String id;
    misskey.User? user;

    try {
      final tuple = await loginAlt(requestOAuth);
      user = tuple.item1;
      token = tuple.item2;
    } catch (e, s) {
      _logger.w(
        "Failed to login using the conventional method. Trying MiAuth instead...",
        e,
        s,
      );

      try {
        final response = await loginMiAuth(session, requestOAuth);
        user = response.user;
        token = response.token;
      } catch (e, s) {
        _logger.w(
          "Failed to login using MiAuth. Trying private endpoints instead...",
          e,
          s,
        );

        final signInResponse = await loginPrivate(username, password);
        token = signInResponse.i;
        id = signInResponse.id;
      }
    }

    // Create and set account secret
    final accountSecret = AccountSecret(token);
    client.authenticationData = MisskeyAuthenticationData(token);

    // Check whether secrets work, and if we can get an account back
    user ??= await client.showUser(id);
    if (user == null) {
      return const LoginResult.failed(
        Tuple2(AuthenticationException("Failed to retrieve user info"), null),
      );
    }

    final account = Account(
      adapter: this,
      user: toUser(user),
      key: AccountKey(ApiType.misskey, instance, username),
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

    return toPost(note);
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
  Future<Iterable<Post>> getTimeline(
    TimelineKind type, {
    String? sinceId,
    String? untilId,
  }) async {
    Iterable<misskey.Note> notes;

    final request = MisskeyTimelineRequest(sinceId: sinceId, untilId: untilId);

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

    return notes.map(toPost);
  }

  @override
  Future<Iterable<ChatMessage>> getChatMessages(Chat chat) {
    throw UnimplementedError();
  }

  @override
  Future<Iterable<Post>> getStatusesOfUserById(String id) async {
    final notes = await client.showUserNotes(id, true, [
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
  Future<Post> addReaction(Post post, Emoji emoji) async {
    String emojiName;

    if (emoji is CustomEmoji) {
      emojiName = ':${emoji.name}:';
    } else if (emoji is UnicodeEmoji) {
      emojiName = emoji.name;
    } else {
      throw UnimplementedError(
        "Emoji type ${emoji.runtimeType} is not supported yet.",
      );
    }

    await client.createReaction(post.id, emojiName);

    // HACK(Craftplacer): We don't get the updated note back from the API, so we have to fetch it again.
    final note = await client.showNote(post.id);
    return toPost(note);
  }

  @override
  Future<Post> removeReaction(Post post, Emoji emoji) async {
    // The "emoji" parameter is ignored,
    // because in Misskey you can only react once.
    await client.deleteReaction(post.id);

    // HACK(Craftplacer): We don't get the updated note back from the API, so we have to fetch it again.
    final note = await client.showNote(post.id);
    return toPost(note);
  }

  @override
  Future<Iterable<EmojiCategory>> getEmojis() async {
    final instanceMeta = await client.getInstanceMeta();
    final emojiCategories = instanceMeta.emojis.groupBy((e) => e.category);
    return emojiCategories.entries.map(
      (kv) => EmojiCategory(kv.key, kv.value.map(toEmoji)),
    );
  }

  @override
  Future<Iterable<Post>> getThread(Post reply) async {
    final notes = await client.getConversation(reply.id);
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
  Future<Post?> repeatPost(String id) async {
    final note = await client.createRenote(id);
    return toPost(note);
  }

  @override
  Future<Post?> unrepeatPost(String id) => throw UnimplementedError();

  @override
  Future<List<User>> getRepeatees(String id) async {
    final notes = await client.getRenotes(id);
    return notes.map((n) => n.user).map(toUserFromLite).toList();
  }
}
