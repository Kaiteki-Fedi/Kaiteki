import 'dart:async';

import 'package:collection/collection.dart';
import 'package:crypto/crypto.dart';
import 'package:fediverse_objects/misskey.dart' as misskey;
import 'package:kaiteki_core/kaiteki_core.dart';
import 'package:logging/logging.dart';
import 'package:uuid/uuid.dart';

import 'capabilities.dart';
import 'client.dart';
import 'exception.dart';
import 'extensions.dart';
import 'requests/sign_in.dart';
import 'responses/signin.dart';

// TODO(Craftplacer): Consider adding additional permissions based on version like Milktea, https://github.com/pantasystem/Milktea/blob/develop/features/auth/src/main/java/net/pantasystem/milktea/auth/viewmodel/Permissions.kt
const List<String> permissions = [
  'write:user-groups',
  'read:user-groups',
  'read:page-likes',
  'write:page-likes',
  'write:pages',
  'read:pages',
  'write:votes',
  'write:reactions',
  'read:reactions',
  'write:notifications',
  'read:notifications',
  'write:notes',
  'write:mutes',
  'read:mutes',
  'read:account',
  'write:account',
  'read:blocks',
  'write:blocks',
  'read:drive',
  'write:drive',
  'read:favorites',
  'write:favorites',
  'read:following',
  'write:following',
  'read:messaging',
  'write:messaging',
];

// TODO(Craftplacer): add missing implementations
class MisskeyAdapter extends DecentralizedBackendAdapter
    implements
        ChatSupport,
        ReactionSupport,
        CustomEmojiSupport,
        NotificationSupport,
        MuteSupport,
        SearchSupport,
        ListSupport,
        PostTranslationSupport,
        LoginSupport,
        OAuthReceiver {
  final MisskeyClient client;

  static final _logger = Logger('MisskeyAdapter');

  @override
  String get instance => client.instance;

  @override
  final ApiType type;

  static Future<MisskeyAdapter> create(ApiType type, String instance) async {
    final client = MisskeyClient(instance);
    final meta = await client.getMeta();
    return MisskeyAdapter._(
      type,
      client,
      MisskeyCapabilities.fromMeta(meta),
    );
  }

  MisskeyAdapter._(this.type, this.client, this.capabilities);

  @override
  Future<User> getUser(String username, [String? instance]) async {
    final user = await client.showUserByName(username, instance);
    return user.toKaiteki(this.instance);
  }

  @override
  Future<User> getUserById(String id) async {
    final user = await client.showUser(id);
    return user.toKaiteki(instance);
  }

  Future<LoginResult?> loginMiAuth(LoginContext context) async {
    final requestOAuth = context.requestOAuth;
    if (requestOAuth == null) return null;

    final session = Uuid().v4();

    return await requestOAuth((oauthUrl) async {
      final uri = Uri.https(instance, '/miauth/$session', {
        'name': context.application.name,
        'icon': context.application.icon!,
        'callback': oauthUrl.toString(),
        'permission': permissions.join(','),
      });

      return (uri, {'session': session});
    });
  }

  Future<LoginResult> loginAlt(LoginContext context) async {
    late final String appSecret;
    late final String sessionToken;

    return await context.requestOAuth!((oauthUrl) async {
      final app = await client.createApp(
        context.application.name,
        context.application.description,
        permissions,
        callbackUrl: oauthUrl.toString(),
      );

      appSecret = app.secret;

      final session = await client.generateSession(app.secret);
      sessionToken = session.token;

      return (
        Uri.parse(session.url),
        {'secret': appSecret, 'token': sessionToken},
      );
    });
  }

  Future<SignInResponse> loginPrivate(
    String username,
    String password,
  ) async {
    return client.signIn(
      MisskeySignInRequest(username: username, password: password),
    );
  }

  @override
  Future<LoginResult> login(LoginContext context) async {
    try {
      return await loginAlt(context);
    } catch (e, s) {
      _logger.warning(
        'Failed to login using the conventional method. Trying MiAuth instead...',
        e,
        s,
      );
    }

    try {
      final result = await loginMiAuth(context);
      if (result != null) return result;
    } catch (e, s) {
      _logger.warning(
        'Failed to login using MiAuth. Trying private endpoints instead...',
        e,
        s,
      );
    }

    return LoginFailure((UnsupportedError('No available login method.'), null));
  }

  @override
  Future<Post> postStatus(PostDraft draft, {Post? parentPost}) async {
    var poll = draft.poll;
    final response = await client.createNote(
      visibility: misskeyVisibilityRosetta.getLeft(draft.visibility),
      text: draft.content,
      cw: draft.subject,
      replyId: draft.replyTo?.id,
      fileIds: draft.attachments
          .map((a) => a.source)
          .cast<misskey.DriveFile>()
          .map((a) => a.id)
          .toList(),
      poll: poll == null
          ? null
          : (
              choices: poll.options,
              expiredAfter: poll.deadline
                  .safeCast<RelativeDeadline>()
                  ?.duration
                  .inMilliseconds,
              expiresAt: poll.deadline
                  .safeCast<AbsoluteDeadline>()
                  ?.endsAt
                  .millisecondsSinceEpoch,
              multiple: poll.allowMultipleChoices
            ),
    );

    return response.createdNote.toKaiteki(instance);
  }

  @override
  Future<User> getMyself() async {
    final user = await client.getI();
    return user.toKaiteki(instance);
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
                    resolvedUsers.map((e) => e.toKaiteki(instance)).toList(),
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
              recipient: e.recipient!.toKaiteki(instance),
              lastMessage: e.toKaiteki(instance),
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
    TimelineType type, {
    TimelineQuery<String>? query,
  }) async {
    Iterable<misskey.Note> notes;

    final request = MisskeyTimelineRequest(
      sinceId: query?.sinceId,
      untilId: query?.untilId,
    );

    notes = switch (type) {
      TimelineType.following => await client.getTimeline(request),
      TimelineType.local => await client.getLocalTimeline(request),
      TimelineType.recommended => await client.getRecommendedTimeline(request),
      TimelineType.hybrid => await client.getHybridTimeline(request),
      TimelineType.federated => await client.getGlobalTimeline(request),
      _ => throw UnsupportedError('Timeline type $type is not supported.'),
    };

    return notes.map((n) => n.toKaiteki(instance)).toList();
  }

  @override
  Future<Iterable<ChatMessage>> getChatMessages(ChatTarget chat) async {
    final messages = await client.getMessages(
      userId: chat is DirectChat ? chat.id : null,
      groupId: chat is GroupChat ? chat.id : null,
    );
    return messages.map((e) => e.toKaiteki(instance));
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
        'image/jpeg',
        'image/png',
        'image/gif',
        'image/apng',
        'image/vnd.mozilla.apng'
      ],
      sinceId: query?.sinceId,
      untilId: query?.untilId,
    );
    return notes.map((n) => n.toKaiteki(instance)).toList();
  }

  @override
  Future<ChatMessage> postChatMessage(ChatTarget chat, ChatMessage message) {
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
        'Emoji type ${emoji.runtimeType} is not supported yet.',
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
      if (e.code != 'NOT_REACTED') rethrow;
    }
  }

  @override
  Future<List<EmojiCategory>> getEmojis() async {
    final instanceMeta = await client.getMeta();
    var emojis = instanceMeta.emojis;

    emojis ??= (await client.getEmojis()).emojis;

    final emojiCategories = emojis.groupListsBy((e) => e.category);
    return emojiCategories.entries
        .map(
          (kv) => EmojiCategory.withVariants(
            kv.key,
            kv.value //
                .map((e) => e.toKaiteki(instance))
                .map(EmojiCategoryItem.new)
                .toList(),
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
      _logger.fine('Failed to fetch thread using notes/conversation', e, s);

      // FIXME(Craftplacer): Fetch (entire thread), or implement incomplete threads (will be a nightmare to do)
      notes = await client.getNoteChildren(reply.id);
    }

    return notes.map((n) => n.toKaiteki(instance)).followedBy([reply]);
  }

  @override
  Future<Instance> getInstance() async {
    final instance = await client.getMeta();
    return instance.toKaiteki(client.client.baseUri);
  }

  @override
  Future<Instance> probeInstance() async {
    return getInstance();
  }

  @override
  Future<User?> followUser(String id) async {
    await client.followUser(id);
    return null;
  }

  @override
  Future<Post> getPostById(String id) {
    // TODO(Craftplacer): implement getPostById
    throw UnimplementedError();
  }

  @override
  Future<Attachment> uploadAttachment(AttachmentDraft draft) async {
    final driveFile = await client.createDriveFile(
      await draft.file!.toMultipartFile('file'),
      comment: draft.description,
      isSensitive: draft.isSensitive,
    );
    return driveFile.toKaiteki();
  }

  @override
  final MisskeyCapabilities capabilities;

  @override
  Future<void> repeatPost(String id) async => client.createRenote(id);

  @override
  Future<void> unrepeatPost(String id) => throw UnimplementedError();

  @override
  Future<List<User>> getRepeatees(String id) async {
    final notes = await client.getRenotes(id);
    return notes.map((n) => n.user.toKaiteki(instance)).toList();
  }

  @override
  Future<void> clearAllNotifications() =>
      throw UnsupportedError('Misskey does not support clearing notifications');

  @override
  Future<List<Notification>> getNotifications(
      {String? sinceId, String? untilId}) async {
    final notifications = await client.getNotifications(
      sinceId: sinceId,
      untilId: untilId,
    );
    return notifications.map((n) => n.toKaiteki(instance)).toList();
  }

  @override
  Future<void> markAllNotificationsAsRead() =>
      client.markAllNotificationsAsRead();

  @override
  Future<void> markNotificationAsRead(Notification notification) {
    throw UnsupportedError(
      'Misskey does not support marking individual notifications as read',
    );
  }

  @override
  FutureOr<void> applySecrets(
    ClientSecret? clientSecret,
    UserSecret userSecret,
  ) {
    super.applySecrets(clientSecret, userSecret);
    client.i = userSecret.accessToken;
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
    return notes.map((n) => n.toKaiteki(instance)).toList();
  }

  @override
  Future<List<User>> searchForUsers(String query) async {
    final users = await client.searchUsers(query);
    return users.map((u) => u.toKaiteki(instance)).toList();
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
    return notes.map((n) => n.toKaiteki(instance)).toList();
  }

  @override
  Future<List<User>> getListUsers(String listId) async {
    final list = await client.showList(listId);
    final userIds = list.userIds;
    var users = const <misskey.User>[];

    if (userIds != null && userIds.isNotEmpty) {
      users = await client.showUsers(userIds.toSet());
    }

    return users.map((e) => e.toKaiteki(instance)).toList();
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
      users.map((e) => e.follower!.toKaiteki(instance)).toList(),
      null,
      users.lastOrNull?.followerId,
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
      users.map((e) => e.followee!.toKaiteki(instance)).toList(),
      null,
      users.lastOrNull?.followeeId,
    );
  }

  @override
  Future<Post> translatePost(Post post, String targetLanguage) async {
    final response = await client.translateNote(post.id, targetLanguage);
    return post.copyWith(content: response.text);
  }

  @override
  Future<User> lookupUser(String username, [String? host]) async {
    final users = await client.searchUsersByUsernameAndHost(username, host);
    final user =
        users.firstWhere((e) => e.host == host && e.username == username);
    return user.toKaiteki(instance);
  }

  @override
  Future<PaginatedSet<String, User>> getMutedUsers({
    String? previousId,
    String? nextId,
  }) async {
    final mutes = await client.getMutedAccounts(previousId, nextId);
    return PaginatedSet(
      mutes.map((e) => e.mutee.toKaiteki(instance)).toSet(),
      previousId,
      nextId,
    );
  }

  @override
  Future<void> muteUser(String userId) async {
    await client.muteUser(userId);
  }

  @override
  Future<void> unmuteUser(String userId) async {
    await client.unmuteUser(userId);
  }

  @override
  Future<User?> unfollowUser(String id) async {
    await client.unfollowUser(id);
    return null;
  }

  @override
  Future<Object?> resolveUrl(Uri url) {
    // TODO: implement resolveUrl
    throw UnimplementedError();
  }

  @override
  Future<LoginResult> handleOAuth(
    Map<String, String> query,
    Map<String, String>? extra,
  ) async {
    String? token;
    misskey.User? user;

    final session = extra?['session'];
    if (session != null) {
      final response = await client.checkSession(session);
      token = response.token;
      user = response.user;
    }

    final sessionToken = extra?['token'];
    final appSecret = extra?['secret'];
    if (appSecret != null && sessionToken != null) {
      final response = await client.userkey(appSecret, sessionToken);
      user = response.user!;

      final concat = response.accessToken + appSecret;
      token = sha256.convert(concat.codeUnits).toString();
    }

    if (token == null || user == null) {
      return LoginAborted();
    }

    client.i = token;
    authenticated = true;

    return LoginSuccess(
      user: user.toKaiteki(instance),
      userSecret: (
        accessToken: token,
        refreshToken: null,
        userId: null,
      ),
    );
  }
}
