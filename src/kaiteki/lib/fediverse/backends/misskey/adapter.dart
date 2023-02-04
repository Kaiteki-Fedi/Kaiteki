import "dart:async";
import "dart:developer";

import "package:collection/collection.dart";
import "package:crypto/crypto.dart";
import "package:fediverse_objects/misskey.dart" as misskey;
import "package:intl/intl.dart";
import "package:kaiteki/auth/login_typedefs.dart";
import "package:kaiteki/constants.dart" as consts;
import "package:kaiteki/fediverse/adapter.dart";
import "package:kaiteki/fediverse/api_type.dart";
import "package:kaiteki/fediverse/backends/misskey/capabilities.dart";
import "package:kaiteki/fediverse/backends/misskey/client.dart";
import "package:kaiteki/fediverse/backends/misskey/exception.dart";
import "package:kaiteki/fediverse/backends/misskey/model/list.dart";
import "package:kaiteki/fediverse/backends/misskey/requests/sign_in.dart";
import "package:kaiteki/fediverse/backends/misskey/requests/timeline.dart";
import "package:kaiteki/fediverse/backends/misskey/responses/check_session.dart";
import "package:kaiteki/fediverse/backends/misskey/responses/signin.dart";
import "package:kaiteki/fediverse/interfaces/chat_support.dart";
import "package:kaiteki/fediverse/interfaces/custom_emoji_support.dart";
import "package:kaiteki/fediverse/interfaces/list_support.dart";
import "package:kaiteki/fediverse/interfaces/notification_support.dart";
import "package:kaiteki/fediverse/interfaces/post_translation_support.dart";
import "package:kaiteki/fediverse/interfaces/reaction_support.dart";
import "package:kaiteki/fediverse/interfaces/search_support.dart";
import "package:kaiteki/fediverse/model/model.dart";
import "package:kaiteki/fediverse/model/notification.dart";
import "package:kaiteki/fediverse/model/timeline_query.dart";
import "package:kaiteki/logger.dart";
import "package:kaiteki/model/auth/account.dart";
import "package:kaiteki/model/auth/account_key.dart";
import "package:kaiteki/model/auth/login_result.dart";
import "package:kaiteki/model/auth/secret.dart";
import "package:kaiteki/model/file.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki/utils/rosetta.dart";
import "package:kaiteki/utils/utils.dart";
import "package:tuple/tuple.dart";
import "package:uuid/uuid.dart";

part "adapter.c.dart";

final _logger = getLogger("MisskeyAdapter");

// TODO(Craftplacer): add missing implementations
class MisskeyAdapter extends DecentralizedBackendAdapter
    implements
        ChatSupport,
        ReactionSupport,
        CustomEmojiSupport,
        NotificationSupport,
        SearchSupport,
        ListSupport,
        PostTranslationSupport {
  final MisskeyClient client;

  @override
  final String instance;

  factory MisskeyAdapter(String instance) {
    return MisskeyAdapter.custom(instance, MisskeyClient(instance));
  }

  MisskeyAdapter.custom(this.instance, this.client);

  @override
  Future<User> getUser(String username, [String? instance]) async {
    final mkUser = await client.showUserByName(username, instance);
    return toUser(mkUser, this.instance);
  }

  @override
  Future<User> getUserById(String id) async {
    return toUser(await client.showUser(id), instance);
  }

  Future<CheckSessionResponse?> loginMiAuth(
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
    late final String appSecret;
    late final String sessionToken;
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

  Future<SignInResponse> loginPrivate(
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
    CredentialsCallback requestCredentials,
    MfaCallback requestMfa,
    OAuthCallback requestOAuth,
  ) async {
    final credentials = await authenticate(requestCredentials, requestOAuth);

    if (credentials == null) return const LoginResult.aborted();

    assert(
      !(credentials.item3 == null && credentials.item2 == null),
      "Both user and id are null",
    );

    client.i = credentials.item1;

    final user = credentials.item3 ?? await client.showUser(credentials.item2!);
    final account = Account(
      adapter: this,
      user: toUser(user, instance),
      key: AccountKey(ApiType.misskey, instance, user.username),
      clientSecret: null,
      accountSecret: AccountSecret(credentials.item1),
    );

    return LoginResult.successful(account);
  }

  @override
  Future<Post> postStatus(PostDraft draft, {Post? parentPost}) async {
    final response = await client.createNote(
      visibility: misskeyVisibilityRosetta.getLeft(draft.visibility),
      text: draft.content,
      cw: draft.subject,
      replyId: draft.replyTo?.id,
      fileIds: draft.attachments.map((a) {
        return (a.source as misskey.DriveFile).id;
      }).toList(),
    );

    return toPost(response.createdNote, instance);
  }

  @override
  Future<User> getMyself() async {
    return toUser(await client.getI(), instance);
  }

  @override
  Future<Iterable<ChatTarget>> getChats() async {
    final groupChats = await client.getMessagingHistory().then(
      (groupMessages) async {
        return Future.wait(
          groupMessages.map(
            (e) async {
              final userIds = e.group!.userIds;
              final resolvedUsers = userIds != null && userIds.isNotEmpty
                  ? await client.showUsers(userIds.toSet())
                  : const <misskey.User>[];
              return GroupChat(
                source: e,
                name: e.group!.name,
                id: e.groupId!,
                createdAt: e.createdAt,
                recipients:
                    resolvedUsers.map((e) => toUser(e, instance)).toList(),
              );
            },
          ),
        );
      },
    );
    final directChats = await client.getMessagingHistory(group: false).then(
      (directMessages) async {
        return Future.wait(
          directMessages.map(
            (e) async => DirectChat(
              source: e,
              id: e.recipientId!,
              recipient: toUserFromLite(e.recipient!, instance),
              lastMessage: toChatMessage(e, instance),
              unread: e.isRead == false,
            ),
          ),
        );
      },
    );

    return [...groupChats, ...directChats];
  }

  @override
  Future<List<Post>> getTimeline(
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

      case TimelineKind.local:
        notes = await client.getLocalTimeline(request);
        break;

      case TimelineKind.bubble:
        notes = await client.getBubbleTimeline(request);
        break;

      case TimelineKind.hybrid:
        notes = await client.getHybridTimeline(request);
        break;

      case TimelineKind.federated:
        notes = await client.getGlobalTimeline(request);
        break;

      // ignore: no_default_cases
      default:
        throw UnimplementedError(
          "Fetching of timeline type $type is not implemented yet.",
        );
    }

    return notes.map((n) => toPost(n, instance)).toList();
  }

  @override
  Future<Iterable<ChatMessage>> getChatMessages(ChatTarget chat) async {
    final messages = await client.getMessages(
      userId: chat is DirectChat ? chat.id : null,
      groupId: chat is GroupChat ? chat.id : null,
    );
    return messages.map((e) => toChatMessage(e, instance));
  }

  @override
  Future<List<Post>> getStatusesOfUserById(
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
    return notes.map((n) => toPost(n, instance)).toList();
  }

  @override
  Future<ChatMessage> postChatMessage(ChatTarget chat, ChatMessage message) {
    throw UnimplementedError();
  }

  @override
  Future<void> addReaction(Post post, Emoji emoji) async {
    String emojiName;

    if (emoji is CustomEmoji) {
      emojiName = ":${emoji.short}:";
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
    final instanceMeta = await client.getMeta();
    var emojis = instanceMeta.emojis;

    emojis ??= (await client.getEmojis()).emojis;

    final emojiCategories = emojis.groupBy((e) => e.category);
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
    List<misskey.Note> notes;

    try {
      notes = await client.getConversation(reply.id);
    } catch (e, s) {
      log(
        "Failed to fetch thread using notes/conversation",
        error: e,
        stackTrace: s,
      );

      // FIXME(Craftplacer): Fetch (entire thread), or implement incomplete threads (will be a nightmare to do)
      notes = await client.getNoteChildren(reply.id);
    }

    return notes.map((n) => toPost(n, instance)).followedBy([reply]);
  }

  @override
  Future<Instance> getInstance() async {
    return toInstance(
      await client.getMeta(),
      client.client.baseUri.toString(),
    );
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
        .map((u) => toUserFromLite(u, instance))
        .toList();
  }

  @override
  Future<void> clearAllNotifications() =>
      throw UnsupportedError("Misskey does not support clearing notifications");

  @override
  Future<List<Notification>> getNotifications() async {
    final notifications = await client.getNotifications();
    return notifications.map((n) => toNotification(n, instance)).toList();
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

  @override
  FutureOr<void> applySecrets(
    ClientSecret? clientSecret,
    AccountSecret accountSecret,
  ) {
    client.i = accountSecret.accessToken;
  }

  @override
  Future<SearchResults> search(String query) async {
    return SearchResults(
      users: await searchForUsers(query),
      posts: await searchForPosts(query),
    );
  }

  @override
  Future<List<String>> searchForHashtags(String query) {
    throw UnimplementedError();
  }

  @override
  Future<List<Post>> searchForPosts(String query) async {
    final notes = await client.searchNotes(query);
    return notes.map((n) => toPost(n, instance)).toList();
  }

  @override
  Future<List<User>> searchForUsers(String query) async {
    final users = await client.searchUsers(query);
    return users.map((u) => toUserFromLite(u, instance)).toList();
  }

  @override
  Future<void> addUserToList(String listId, User user) async {
    await client.pushToList(listId, user.id);
  }

  @override
  Future<PostList> createList(String name) async {
    final list = await client.createList(name);
    return toList(list);
  }

  @override
  Future<void> deleteList(String listId) => client.deleteList(listId);

  @override
  Future<List<Post>> getListPosts(
    String listId, {
    TimelineQuery<String>? query,
  }) async {
    final request = MisskeyTimelineRequest(
      sinceId: query?.sinceId,
      untilId: query?.untilId,
    );
    final notes = await client.getUserListTimeline(listId, request);
    return notes.map((n) => toPost(n, instance)).toList();
  }

  @override
  Future<List<User>> getListUsers(String listId) async {
    final list = await client.showList(listId);
    final userIds = list.userIds;
    var users = const <misskey.User>[];

    if (userIds != null && userIds.isNotEmpty) {
      users = await client.showUsers(userIds.toSet());
    }

    return users.map((e) => toUser(e, instance)).toList();
  }

  @override
  Future<List<PostList>> getLists() async {
    final lists = await client.listLists();
    return lists.map(toList).toList();
  }

  @override
  Future<void> removeUserFromList(String listId, User user) async {
    await client.pullFromList(listId, user.id);
  }

  @override
  Future<void> renameList(String listId, String name) async {
    await client.updateList(listId, name);
  }

  @override
  Future<PaginatedList<String?, User>> getFollowers(
    String userId, {
    String? sinceId,
    String? untilId,
  }) async {
    final users = await client.getUserFollowers(
      userId,
      sinceId: sinceId,
      untilId: untilId,
    );
    return PaginatedList(
      users.map((e) => toUser(e.follower!, instance)).toList(),
      null,
      users.last.followerId,
    );
  }

  @override
  Future<PaginatedList<String?, User>> getFollowing(
    String userId, {
    String? sinceId,
    String? untilId,
  }) async {
    final users = await client.getUserFollowing(
      userId,
      sinceId: sinceId,
      untilId: untilId,
    );
    return PaginatedList(
      users.map((e) => toUser(e.followee!, instance)).toList(),
      null,
      users.last.followeeId,
    );
  }

  @override
  Future<Post> translatePost(Post post, String targetLanguage) async {
    final response = await client.translateNote(post.id, targetLanguage);
    return post.copyWith(content: response.text);
  }

  @override
  Future<void> deleteAccount(String password) {
    // TODO(Craftplacer): implement deleteAccount
    throw UnimplementedError();
  }
}
