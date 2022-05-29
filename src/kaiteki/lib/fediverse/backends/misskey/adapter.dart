import 'package:fediverse_objects/misskey.dart' as misskey;
import 'package:intl/intl.dart';
import 'package:kaiteki/account_manager.dart';
import 'package:kaiteki/constants.dart' as consts;
import 'package:kaiteki/fediverse/adapter.dart';
import 'package:kaiteki/fediverse/backends/misskey/client.dart';
import 'package:kaiteki/fediverse/backends/misskey/requests/sign_in.dart';
import 'package:kaiteki/fediverse/backends/misskey/requests/timeline.dart';
import 'package:kaiteki/fediverse/interfaces/chat_support.dart';
import 'package:kaiteki/fediverse/interfaces/reaction_support.dart';
import 'package:kaiteki/fediverse/model/attachment.dart';
import 'package:kaiteki/fediverse/model/chat.dart';
import 'package:kaiteki/fediverse/model/chat_message.dart';
import 'package:kaiteki/fediverse/model/emoji.dart';
import 'package:kaiteki/fediverse/model/emoji_category.dart';
import 'package:kaiteki/fediverse/model/instance.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/fediverse/model/post_draft.dart';
import 'package:kaiteki/fediverse/model/timeline_type.dart';
import 'package:kaiteki/fediverse/model/user.dart';
import 'package:kaiteki/fediverse/model/visibility.dart';
import 'package:kaiteki/model/auth/account_compound.dart';
import 'package:kaiteki/model/auth/account_secret.dart';
import 'package:kaiteki/model/auth/authentication_data.dart';
import 'package:kaiteki/model/auth/client_secret.dart';
import 'package:kaiteki/model/auth/login_result.dart';
import 'package:kaiteki/model/file.dart';
import 'package:kaiteki/utils/extensions/iterable.dart';
import 'package:uuid/uuid.dart';

part 'adapter.c.dart';

// TODO(Craftplacer): add missing implementations
class MisskeyAdapter extends FediverseAdapter<MisskeyClient>
    implements ChatSupport, ReactionSupport {
  factory MisskeyAdapter({MisskeyClient? client}) {
    return MisskeyAdapter._(client ?? MisskeyClient());
  }

  MisskeyAdapter._(MisskeyClient client) : super(client);

  @override
  Future<User> getUser(String username, [String? instance]) async {
    final mkUser = await client.showUserByName(username, instance);
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
    requestMfa,
    requestOAuth,
    AccountManager accounts,
  ) async {
    client.instance = instance;

    final session = const Uuid().v4();
    late final misskey.User user;
    late final String token;
    late final String id;

    if (consts.useOAuth) {
      await requestOAuth((oauthUrl) async {
        return Uri.https(instance, "/miauth/$session", {
          "name": consts.appName,
          "icon": consts.appRemoteIcon,
          "callback": oauthUrl.toString(),
          "permission": consts.defaultMisskeyPermissions.join(","),
        });
      });

      final details = await client.checkSession(session);
      user = details.user;
      token = details.token;
    } else {
      final authResponse = await client.signIn(
        MisskeySignInRequest(
          username: username,
          password: password,
        ),
      );

      token = authResponse.i;
      id = authResponse.id;
    }

    // Create and set account secret
    final accountSecret = AccountSecret(instance, username, token);
    client.authenticationData = MisskeyAuthenticationData(token);

    if (!consts.useOAuth) {
      // Check whether secrets work, and if we can get an account back
      final user = await client.showUser(id);
      if (user == null) {
        return LoginResult.failed("Failed to retrieve user info");
      }
    }

    final compound = AccountCompound(
      container: accounts,
      adapter: this,
      account: toUser(user),
      clientSecret: ClientSecret(instance, "", "", apiType: client.type),
      accountSecret: accountSecret,
    );
    await accounts.addCurrentAccount(compound);

    return LoginResult.successful();
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
    TimelineType type, {
    String? sinceId,
    String? untilId,
  }) async {
    Iterable<misskey.Note> notes;

    final request = MisskeyTimelineRequest(sinceId: sinceId, untilId: untilId);

    switch (type) {
      case TimelineType.home:
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
  bool supportsCustomEmoji = true;

  @override
  bool supportsUnicodeEmoji = true;

  @override
  Future<void> addReaction(Post post, Emoji emoji) async {
    final note = post.source as misskey.Note;

    String emojiName;

    if (emoji is CustomEmoji) {
      emojiName = ':${emoji.name}:';
    } else if (emoji is UnicodeEmoji) {
      emojiName = emoji.source!;
    } else {
      return;
    }

    await client.createReaction(note.id, emojiName);
  }

  @override
  Future<void> removeReaction(Post post, Emoji emoji) async {
    final note = post.source as misskey.Note;

    // The "emoji" parameter is ignored,
    // because in Misskey you can only react once.
    await client.deleteReaction(note.id);
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
  Future<Post?> favoritePost(String id) {
    // TODO(Craftplacer): implement favoritePost
    throw UnimplementedError();
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
}
