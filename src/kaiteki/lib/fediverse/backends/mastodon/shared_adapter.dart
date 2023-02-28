import "package:collection/collection.dart";
import "package:fediverse_objects/mastodon.dart" as mastodon;
import "package:fediverse_objects/pleroma.dart" as pleroma;
import "package:flutter/foundation.dart";
import "package:kaiteki/auth/login_typedefs.dart";
import "package:kaiteki/constants.dart" as consts;
import "package:kaiteki/exceptions/authentication_exception.dart";
import "package:kaiteki/fediverse/adapter.dart";
import "package:kaiteki/fediverse/backends/mastodon/adapter.dart";
import "package:kaiteki/fediverse/backends/mastodon/capabilities.dart";
import "package:kaiteki/fediverse/backends/mastodon/client.dart";
import "package:kaiteki/fediverse/backends/mastodon/responses/login.dart";
import "package:kaiteki/fediverse/backends/mastodon/responses/marker.dart";
import "package:kaiteki/fediverse/backends/pleroma/exceptions/mfa_required.dart";
import "package:kaiteki/fediverse/interfaces/bookmark_support.dart";
import "package:kaiteki/fediverse/interfaces/custom_emoji_support.dart";
import "package:kaiteki/fediverse/interfaces/favorite_support.dart";
import "package:kaiteki/fediverse/interfaces/list_support.dart";
import "package:kaiteki/fediverse/interfaces/mute_support.dart";
import "package:kaiteki/fediverse/interfaces/notification_support.dart";
import "package:kaiteki/fediverse/interfaces/search_support.dart";
import "package:kaiteki/fediverse/model/model.dart";
import "package:kaiteki/fediverse/model/notification.dart";
// ignore: unnecessary_import, Dart Analyzer is fucking with me
import "package:kaiteki/fediverse/model/timeline_kind.dart";
import "package:kaiteki/fediverse/model/timeline_query.dart";
import "package:kaiteki/model/auth/account.dart";
import "package:kaiteki/model/auth/account_key.dart";
import "package:kaiteki/model/auth/login_result.dart";
import "package:kaiteki/model/auth/secret.dart";
import "package:kaiteki/model/file.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki/utils/rosetta.dart";
import "package:tuple/tuple.dart";
import "package:url_launcher/url_launcher.dart";

part "shared_adapter.c.dart"; // That file contains toEntity() methods

const kOob = "urn:ietf:wg:oauth:2.0:oob";

/// A class that allows Mastodon-derivatives (e.g. Pleroma and Mastodon itself)
/// to use pre-existing code.
abstract class SharedMastodonAdapter<T extends MastodonClient>
    extends DecentralizedBackendAdapter
    implements
        CustomEmojiSupport,
        FavoriteSupport,
        BookmarkSupport,
        NotificationSupport,
        SearchSupport,
        ListSupport,
        MuteSupport {
  final T client;

  SharedMastodonAdapter(this.client);

  @override
  Future<User> getUserById(String id) async {
    return toUser(await client.getAccount(id), instance);
  }

  @override
  Future<LoginResult> login(
    ClientSecret? clientSecret,
    CredentialsCallback requestCredentials,
    CodeCallback requestCode,
    OAuthCallback requestOAuth,
  ) async {
    late final String accessToken;
    late final mastodon.Application application;

    Future<mastodon.Application> createApplication(String redirect) async {
      return client.createApplication(
        instance,
        consts.appName,
        consts.appWebsite,
        redirect,
        consts.defaultScopes,
      );
    }

    final scopes = consts.defaultScopes.join(" ");

    if (consts.useOAuth) {
      late final String url;

      final response = await requestOAuth((oauthUrl) async {
        application = await createApplication(url = oauthUrl.toString());

        return Uri.https(
          instance,
          "/oauth/authorize",
          {
            "response_type": "code",
            "client_id": application.clientId,
            "redirect_uri": url,
            "scope": scopes,
          },
        );
      });

      if (response == null) return const LoginResult.aborted();

      final loginResponse = await client.getToken(
        "authorization_code",
        application.clientId!,
        application.clientSecret!,
        url,
        // ignore: unnecessary_null_checks, should never be null even if permitted
        code: response["code"]!,
        scope: scopes,
      );

      accessToken = loginResponse.accessToken!;
    } else if (kIsWeb) {
      application = await createApplication(kOob);
      await launchUrl(
        Uri.https(
          instance,
          "/oauth/authorize",
          {
            "response_type": "code",
            "client_id": application.clientId,
            "redirect_uri": kOob,
            "scope": scopes,
          },
        ),
        mode: LaunchMode.externalApplication,
      );

      LoginResponse? loginResponse;

      await requestCode(const CodePromptOptions(), (code) async {
        loginResponse = await client.getToken(
          "authorization_code",
          application.clientId!,
          application.clientSecret!,
          kOob,
          code: code,
          scope: scopes,
        );
      });

      if (loginResponse == null) return const LoginResult.aborted();

      accessToken = loginResponse!.accessToken!;
    } else {
      application = await createApplication(kOob);

      String? mfaToken;

      final loginResponse = await requestCredentials(
        (credentials) async {
          if (credentials == null) return null;

          try {
            return await client.login(
              credentials.username,
              credentials.password,
              application.clientId!,
              application.clientSecret!,
            );
          } on MfaRequiredException catch (e) {
            mfaToken = e.mfaToken;
            return null;
          }
        },
      );

      if (mfaToken != null) {
        final mfaResponse = await requestCode.call(
          const CodePromptOptions(numericOnly: true),
          (code) => client.respondMfa(
            mfaToken!,
            int.parse(code),
            application.clientId!,
            application.clientSecret!,
          ),
        );

        if (mfaResponse == null) return const LoginResult.aborted();

        accessToken = mfaResponse.accessToken!;
      } else if (loginResponse == null) {
        return const LoginResult.aborted();
      } else {
        accessToken = loginResponse.accessToken!;
      }
    }

    client.accessToken = accessToken;

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
      user: toUser(account, instance),
      clientSecret: ClientSecret(
        application.clientId!,
        application.clientSecret!,
      ),
      accountSecret: AccountSecret(accessToken),
      key: AccountKey(
        type,
        instance,
        account.username,
      ),
    );

    return LoginResult.successful(ktkAccount);
  }

  @override
  Future<Post> postStatus(PostDraft draft, {Post? parentPost}) async {
    final newPost = await client.postStatus(
      draft.content,
      pleromaPreview: false,
      visibility: mastodonVisibilityRosetta.getLeft(draft.visibility),
      spoilerText: draft.subject,
      inReplyToId: draft.replyTo?.id,
      contentType: pleromaFormattingRosetta.getLeft(draft.formatting),
      mediaIds: draft.attachments
          .map((a) => (a.source as mastodon.Attachment).id)
          .toList(),
    );
    return toPost(newPost, instance);
  }

  @override
  Future<User> getMyself() async {
    final account = await client.verifyCredentials();
    return toUser(account, instance);
  }

  @override
  Future<List<Post>> getTimeline(
    TimelineKind type, {
    TimelineQuery<String>? query,
  }) async {
    final Iterable<mastodon.Status> posts;

    switch (type) {
      case TimelineKind.home:
        posts = await client.getHomeTimeline(
          minId: query?.sinceId,
          maxId: query?.untilId,
          onlyMedia: query?.onlyMedia,
        );
        break;

      case TimelineKind.local:
        posts = await client.getPublicTimeline(
          minId: query?.sinceId,
          maxId: query?.untilId,
          onlyMedia: query?.onlyMedia,
          local: true,
        );
        break;

      case TimelineKind.federated:
        posts = await client.getPublicTimeline(
          minId: query?.sinceId,
          maxId: query?.untilId,
          onlyMedia: query?.onlyMedia,
        );
        break;

      default:
        throw UnimplementedError();
    }

    return posts.map((p) => toPost(p, instance)).toList();
  }

  @override
  Future<User> getUser(String username, [String? instance]) async {
    final results = await client.searchAccounts(username);
    final account = results.firstWhere((a) => a.username == username);
    return toUser(account, this.instance);
  }

  @override
  Future<List<EmojiCategory>> getEmojis() async {
    final emojis = await client.getCustomEmojis();
    final categories = emojis.groupBy((emoji) => emoji.category);

    return categories.entries.map((kv) {
      return EmojiCategory(
        kv.key,
        kv.value
            .map(toEmoji)
            .map(EmojiCategoryItem.new)
            .toList(growable: false),
      );
    }).toList();
  }

  @override
  Future<Iterable<Post>> getThread(Post reply) async {
    final status = reply.source as mastodon.Status;
    final context = await client.getStatusContext(status.id);
    return <Post>[
      ...context.ancestors.map((s) => toPost(s, instance)),
      reply,
      ...context.descendants.map((s) => toPost(s, instance)),
    ];
  }

  @override
  Future<Instance> getInstance() => throw UnimplementedError();

  @override
  Future<Instance?> probeInstance() => throw UnimplementedError();

  @override
  Future<Post> getPostById(String id) async {
    final status = await client.getStatus(id);
    return toPost(status, instance);
  }

  @override
  Future<bool> favoritePost(String id) async {
    final status = await client.favouriteStatus(id);
    return status.favourited!;
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
    return statuses.map((p) => toPost(p, instance)).toList();
  }

  @override
  Future<Post?> unbookmarkPost(String id) async {
    final status = await client.unbookmarkStatus(id);
    return toPost(status, instance);
  }

  @override
  Future<List<User>> getFavoritees(String id) async {
    final users = await client.getFavouritedBy(id);
    return users.map((u) => toUser(u, instance)).toList();
  }

  @override
  Future<List<User>> getRepeatees(String id) async {
    final users = await client.getBoostedBy(id);
    return users.map((u) => toUser(u, instance)).toList();
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
    return statuses.map((p) => toPost(p, instance)).toList();
  }

  @override
  Future<List<Notification>> getNotifications() async {
    final Marker? marker;

    if (this is MastodonAdapter) {
      final markers =
          await client.getMarkers(const {MarkerTimeline.notifications});
      marker = markers.notifications;
    } else {
      marker = null;
    }

    final notifications = await client.getNotifications();
    return notifications
        .map((n) => toNotification(n, instance, marker))
        .toList();
  }

  @override
  Future<void> clearAllNotifications() async {
    // TODO(Craftplacer): implement clearAllNotifications
  }

  @override
  void applySecrets(
    ClientSecret? clientSecret,
    AccountSecret accountSecret,
  ) {
    client.accessToken = accountSecret.accessToken;
  }

  @override
  Future<SearchResults> search(String query) async {
    final results = await client.search(query);

    return SearchResults(
      users: results.accounts.map((a) => toUser(a, instance)).toList(),
      posts: results.statuses.map((s) => toPost(s, instance)).toList(),
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
    return lists.map(toList).toList();
  }

  @override
  Future<List<Post>> getListPosts(
    String listId, {
    TimelineQuery? query,
  }) async {
    final posts = await client.getListTimeline(listId);
    return posts.map((p) => toPost(p, instance)).toList();
  }

  @override
  Future<List<User>> getListUsers(String listId) async {
    final users = await client.getListAccounts(listId);
    return users.map((p) => toUser(p, instance)).toList();
  }

  @override
  Future<PostList> createList(String title) async {
    final list = await client.createList(title);
    return toList(list);
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
      pagination.data.map((e) => toUser(e, instance)).toList(),
      pagination.previousParams?["since_id"],
      pagination.nextParams?["max_id"],
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
      pagination.data.map((e) => toUser(e, instance)).toList(),
      pagination.previousParams?["since_id"],
      pagination.nextParams?["max_id"],
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
      pagination.data.map((e) => toUser(e, instance)).toSet(),
      pagination.previousParams?["since_id"],
      pagination.nextParams?["max_id"],
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
    final acct = host == null ? username : "$username@$host";
    final user = await client.lookupAccount(acct);
    return toUser(user, instance);
  }
}
