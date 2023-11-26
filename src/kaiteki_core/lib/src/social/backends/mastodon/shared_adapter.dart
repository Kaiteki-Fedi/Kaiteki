import 'package:collection/collection.dart';
import 'package:fediverse_objects/mastodon.dart' as mastodon;
import 'package:kaiteki_core/kaiteki_core.dart';

import 'adapter.dart';
import 'capabilities.dart';
import 'client.dart';
import 'extensions.dart'; // That file contains toEntity() methods
import 'responses/login.dart';
import 'responses/marker.dart';

final kOob = Uri.parse('urn:ietf:wg:oauth:2.0:oob');

const _scopes = ['read', 'write', 'follow', 'push'];

/// A class that allows Mastodon-derivatives (e.g. Pleroma and Mastodon itself)
/// to use pre-existing code.
abstract class SharedMastodonAdapter<T extends MastodonClient>
    extends DecentralizedBackendAdapter
    implements
        AnnouncementsSupport,
        BookmarkSupport,
        CustomEmojiSupport,
        FavoriteSupport,
        FollowSupport,
        HashtagSupport,
        ListSupport,
        LoginSupport,
        MuteSupport,
        NotificationSupport,
        OAuthReceiver,
        SearchSupport {
  final T client;

  @override
  String get instance => client.instance;

  @override
  final ApiType type;

  SharedMastodonAdapter(this.type, this.client);

  @override
  Future<User> getUserById(String id) async {
    final account = await client.getAccount(id);
    mastodon.Relationship? relationship;

    try {
      relationship = await client.getRelationship(id);
    } catch (_) {}

    return account.toKaiteki(instance, relationship: relationship);
  }

  @override
  Future<LoginResult> login(LoginContext context) async {
    late final mastodon.Application application;

    Future<mastodon.Application> createApplication(Uri redirectUri) async {
      return client.createApplication(
        context.application.name,
        redirectUri,
        website: context.application.website,
        scopes: _scopes,
      );
    }

    final scopes = _scopes.join(' ');

    final requestOAuth = context.requestOAuth;
    if (requestOAuth != null) {
      late final Uri url;

      return await requestOAuth((oauthUrl) async {
        application = await createApplication(url = oauthUrl);

        final authorizationUri = Uri.https(
          instance,
          '/oauth/authorize',
          {
            'response_type': 'code',
            'client_id': application.clientId,
            'redirect_uri': url.toString(),
            'scope': scopes,
          },
        );

        final extra = {
          'id': application.clientId!,
          'secret': application.clientSecret!,
          'redirect': url.toString(),
          'scopes': scopes,
        };

        return (authorizationUri, extra);
      });
    }

    application = await createApplication(kOob);
    await context.openUrl(
      Uri.https(
        instance,
        '/oauth/authorize',
        {
          'response_type': 'code',
          'client_id': application.clientId,
          'redirect_uri': kOob,
          'scope': scopes,
        },
      ),
    );

    LoginResponse? loginResponse;

    await context.requestCode(const CodePromptOptions(), (code) async {
      loginResponse = await client.getToken(
        'authorization_code',
        application.clientId!,
        application.clientSecret!,
        kOob,
        code: code,
        scope: scopes,
      );
    });

    if (loginResponse == null) return const LoginAborted();

    return _applyLoginResult(
      loginResponse!,
      application.clientId!,
      application.clientSecret!,
    );
  }

  Future<LoginResult> _applyLoginResult(
    LoginResponse response,
    String clientId,
    String clientSecret,
  ) async {
    final accessToken = response.accessToken!;

    client.accessToken = accessToken;

    // Check whether secrets work, and if we can get an account back
    mastodon.Account account;

    try {
      account = await client.verifyCredentials();
    } catch (e, s) {
      return LoginFailure((e, s));
    }

    authenticated = true;

    return LoginSuccess(
      user: account.toKaiteki(instance),
      clientSecret: (clientId, clientSecret),
      userSecret: (accessToken: accessToken, refreshToken: null, userId: null),
    );
  }

  @override
  Future<LoginResult> handleOAuth(
    Map<String, String> query,
    Map<String, String>? extra,
  ) async {
    final code = query['code'];

    if (code == null || extra == null) {
      return LoginFailure((StateError('Data is missing'), null));
    }

    final id = extra['id'];
    final secret = extra['secret'];
    final redirectUri = extra['redirect'];
    final scopes = extra['scopes'];

    if (id == null || secret == null || redirectUri == null || scopes == null) {
      return LoginFailure((StateError('Data is missing'), null));
    }

    final response = await client.getToken(
      'authorization_code',
      id,
      secret,
      Uri.parse(redirectUri),
      code: code,
      scope: scopes,
    );

    return _applyLoginResult(response, id, secret);
  }

  @override
  Future<Post> postStatus(PostDraft draft, {Post? parentPost}) async {
    final poll = draft.poll;
    final newPost = await client.postStatus(
      draft.content,
      pleromaPreview: false,
      visibility: mastodonVisibilityRosetta.getLeft(draft.visibility),
      spoilerText: draft.subject,
      inReplyToId: draft.replyTo?.id,
      // TODO(Craftplacer): change UI to allow setting entire post as senstive instead of just individual attachments
      sensitive: draft.attachments.any((e) => e.isSensitive ?? false),
      contentType: pleromaFormattingRosetta.getLeft(draft.formatting),
      mediaIds: draft.attachments
          .map((a) => (a.source as mastodon.MediaAttachment).id)
          .toList(),
      language: draft.language,
      poll: poll == null
          ? null
          : (
              options: poll.options,
              expiresIn: poll.deadline!.ensureRelative().duration.inSeconds,
              multiple: poll.allowMultipleChoices,
              hideTotals: false,
            ),
    );
    return newPost.toKaiteki(instance);
  }

  @override
  Future<User> getMyself() async {
    final account = await client.verifyCredentials();
    return account.toKaiteki(instance);
  }

  @override
  Future<List<Post>> getTimeline(
    TimelineType type, {
    TimelineQuery<String>? query,
  }) async {
    final Iterable<mastodon.Status> posts;

    posts = switch (type) {
      TimelineType.following => await client.getHomeTimeline(
          minId: query?.sinceId,
          maxId: query?.untilId,
          onlyMedia: query?.onlyMedia,
        ),
      TimelineType.local => await client.getPublicTimeline(
          minId: query?.sinceId,
          maxId: query?.untilId,
          onlyMedia: query?.onlyMedia,
          local: true,
        ),
      TimelineType.federated => await client.getPublicTimeline(
          minId: query?.sinceId,
          maxId: query?.untilId,
          onlyMedia: query?.onlyMedia,
        ),
      _ => throw UnimplementedError()
    };

    return posts.map((p) => p.toKaiteki(instance)).toList();
  }

  @override
  Future<User?> getUser(String username, [String? instance]) async {
    final acct = instance == null || instance == this.instance
        ? username
        : '$username@$instance';
    final results = await client.searchAccounts(username);
    final account = results.firstWhereOrNull((a) => a.acct == acct);
    return account?.toKaiteki(this.instance);
  }

  @override
  Future<List<EmojiCategory>> getEmojis() async {
    final emojis = await client.getCustomEmojis();
    final categories = emojis.groupListsBy((emoji) => emoji.category);

    return categories.entries
        .map(
          (kv) => EmojiCategory(
            kv.key,
            kv.value.map((e) => e.toKaiteki(instance)),
          ),
        )
        .toList();
  }

  @override
  Future<Iterable<Post>> getThread(Post reply) async {
    final status = reply.source as mastodon.Status;
    final context = await client.getStatusContext(status.id);
    return <Post>[
      ...context.ancestors.map((s) => s.toKaiteki(instance)),
      reply,
      ...context.descendants.map((s) => s.toKaiteki(instance)),
    ];
  }

  @override
  Future<Post> getPostById(String id) async {
    final status = await client.getStatus(id);
    return status.toKaiteki(instance);
  }

  @override
  Future<bool> favoritePost(String id) async {
    final status = await client.favouriteStatus(id);
    return status.favourited!;
  }

  @override
  Future<User?> followUser(String id) async {
    /* final relationship = */ await client.followAccount(id);
    // TODO(Craftplacer): return updated relationship
    return null;
  }

  @override
  Future<User?> unfollowUser(String id) async {
    /* final relationship = */ await client.unfollowAccount(id);
    // TODO(Craftplacer): return updated relationship
    return null;
  }

  @override
  Future<Attachment> uploadAttachment(AttachmentDraft draft) async {
    final attachment = await client.uploadMedia(draft.file!, draft.description);
    // HACK(Craftplacer): Mastodon doesn't support marking individual attachments as sensitive
    return attachment.toKaiteki().copyWith(isSensitive: draft.isSensitive);
  }

  @override
  MastodonCapabilities get capabilities => const MastodonCapabilities();

  @override
  Future<void> repeatPost(String id) async => client.reblogStatus(id);

  @override
  Future<void> unfavoritePost(String id) async => client.unfavouriteStatus(id);

  @override
  Future<void> unrepeatPost(String id) async => client.unreblogStatus(id);

  @override
  Future<void> bookmarkPost(String id) async => client.bookmarkStatus(id);

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
    return statuses.map((p) => p.toKaiteki(instance)).toList();
  }

  @override
  Future<Post?> unbookmarkPost(String id) async {
    final status = await client.unbookmarkStatus(id);
    return status.toKaiteki(instance);
  }

  @override
  Future<List<User>> getFavoritees(String id) async {
    final users = await client.getFavouritedBy(id);
    return users.map((e) => e.toKaiteki(instance)).toList();
  }

  @override
  Future<List<User>> getRepeatees(String id) async {
    final users = await client.getBoostedBy(id);
    return users.map((e) => e.toKaiteki(instance)).toList();
  }

  @override
  Future<List<Post>> getStatusesOfUserById(
    String id, {
    TimelineQuery<String>? query,
  }) async {
    final statuses = await client.getAccountStatuses(
      id,
      minId: query?.sinceId,
      maxId: query?.untilId,
      onlyMedia: query?.onlyMedia,
      excludeReplies: query?.includeReplies == false,
    );
    return statuses.map((p) => p.toKaiteki(instance)).toList();
  }

  @override
  Future<List<Notification>> getNotifications({
    String? sinceId,
    String? untilId,
  }) async {
    final Marker? marker;

    if (this is MastodonAdapter) {
      final markers =
          await client.getMarkers(const {MarkerTimeline.notifications});
      marker = markers.notifications;
    } else {
      marker = null;
    }

    final notifications = await client.getNotifications(
      sinceId: sinceId,
      maxId: untilId,
    );
    return notifications.map((e) => e.toKaiteki(instance, marker)).toList();
  }

  @override
  Future<void> clearAllNotifications() async {
    // TODO(Craftplacer): implement clearAllNotifications
  }

  @override
  void applySecrets(
    ClientSecret? clientSecret,
    UserSecret userSecret,
  ) {
    super.applySecrets(clientSecret, userSecret);
    client.accessToken = userSecret.accessToken;
  }

  @override
  Future<SearchResults> search(String query) async {
    final results = await client.search(query, resolve: true);

    return SearchResults(
      users: results.accounts.map((a) => a.toKaiteki(instance)).toList(),
      posts: results.statuses.map((s) => s.toKaiteki(instance)).toList(),
      hashtags: results.hashtags.map((e) => e.name).toList(),
    );
  }

  @override
  Future<List<String>> searchForHashtags(String query) {
    // TODO(Craftplacer): implement searchForHashtags
    throw UnimplementedError();
  }

  @override
  Future<List<Post>> searchForPosts(String query) {
    // TODO(Craftplacer): implement searchForPosts
    throw UnimplementedError();
  }

  @override
  Future<List<User>> searchForUsers(String query) {
    // TODO(Craftplacer): implement searchForUsers
    throw UnimplementedError();
  }

  @override
  Future<List<PostList>> getLists() async {
    final lists = await client.getLists();
    return lists.map((e) => e.toKaiteki()).toList();
  }

  @override
  Future<List<Post>> getListPosts(
    String listId, {
    TimelineQuery? query,
  }) async {
    final posts = await client.getListTimeline(
      listId,
      sinceId: query?.sinceId,
      maxId: query?.untilId,
    );
    return posts.map((e) => e.toKaiteki(instance)).toList();
  }

  @override
  Future<List<User>> getListUsers(String listId) async {
    final users = await client.getListAccounts(listId);
    return users.map((e) => e.toKaiteki(instance)).toList();
  }

  @override
  Future<PostList> createList(String title) async {
    final list = await client.createList(title);
    return list.toKaiteki();
  }

  @override
  Future<void> addUserToList(String listId, User user) async {
    await client.addListAccounts(listId, {user.id});
  }

  @override
  Future<void> removeUserFromList(String listId, User user) async {
    await client.removeListAccounts(listId, {user.id});
  }

  @override
  Future<void> deleteList(String listId) async => client.deleteList(listId);

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
    final pagination = await client.getAccountFollowers(
      userId,
    );
    return PaginatedList(
      pagination.data.map((e) => e.toKaiteki(instance)).toList(),
      pagination.previousParams?['since_id'],
      pagination.nextParams?['max_id'],
    );
  }

  @override
  Future<PaginatedList<String?, User>> getFollowing(
    String userId, {
    String? sinceId,
    String? untilId,
  }) async {
    final pagination = await client.getAccountFollowing(userId);
    return PaginatedList(
      pagination.data.map((e) => e.toKaiteki(instance)).toList(),
      pagination.previousParams?['since_id'],
      pagination.nextParams?['max_id'],
    );
  }

  @override
  Future<PaginatedSet<String, User>> getMutedUsers({
    String? previousId,
    String? nextId,
  }) async {
    final pagination = await client.getMutedAccounts(
      sinceId: previousId,
      maxId: nextId,
    );

    return PaginatedSet(
      pagination.data.map((e) => e.toKaiteki(instance)).toSet(),
      pagination.previousParams?['since_id'],
      pagination.nextParams?['max_id'],
    );
  }

  @override
  Future<void> muteUser(String userId) async {
    await client.muteAccount(userId);
  }

  @override
  Future<void> unmuteUser(String userId) async {
    await client.unmuteAccount(userId);
  }

  @override
  Future<User> lookupUser(String username, [String? host]) async {
    final acct = host == null ? username : '$username@$host';
    final user = await client.lookupAccount(acct);
    return user.toKaiteki(instance);
  }

  @override
  Future<Object?> resolveUrl(Uri url) async {
    final results = await client.search(url.toString(), resolve: true);

    // What if the URL is linking to another instance?
    // bool isHostMatch(mastodon.Account account) {
    //   final instance =
    //       account.acct.split('@').elementAtOrNull(1) ?? this.instance;
    //   return instance == url.host;
    // }

    final status = results.statuses.firstOrNull;
    if (status != null) return status.toKaiteki(instance);

    final account = results.accounts.firstOrNull;
    if (account != null) return account.toKaiteki(instance);

    return null;
  }

  @override
  Future<PaginatedSet<String?, User>> getFollowRequests({
    String? sinceId,
    String? untilId,
  }) async {
    final pagination = await client.getFollowRequests(
      sinceId: sinceId,
      maxId: untilId,
    );

    return PaginatedSet(
      pagination.data.map((e) => e.toKaiteki(instance)).toSet(),
      pagination.previousParams?['since_id'],
      pagination.nextParams?['max_id'],
    );
  }

  @override
  Future<void> acceptFollowRequest(String userId) {
    return client.authorizeFollowRequest(userId);
  }

  @override
  Future<void> rejectFollowRequest(String userId) {
    return client.rejectFollowRequest(userId);
  }

  @override
  Future<List<Announcement>> getAnnouncements() async {
    final announcements = await client.getAnnouncements();
    return announcements.map((e) => e.toKaiteki(instance)).toList();
  }

  @override
  Future<void> followHashtag(String hashtag) async {
    await client.followHashtag(hashtag);
  }

  @override
  Future<void> unfollowHashtag(String hashtag) async {
    await client.unfollowHashtag(hashtag);
  }

  @override
  Future<List<Post>> getPostsByHashtag(
    String hashtag, {
    TimelineQuery<String>? query,
  }) async {
    final statuses = await client.getHashtagTimeline(
      hashtag,
      sinceId: query?.sinceId,
      maxId: query?.untilId,
    );
    return statuses.map((e) => e.toKaiteki(instance)).toList();
  }

  @override
  Future<Hashtag> getHashtag(String hashtag) async {
    final tag = await client.getHashtag(hashtag);
    return tag.toKaiteki();
  }
}
