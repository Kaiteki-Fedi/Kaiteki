import 'package:collection/collection.dart';
import 'package:fediverse_objects/mastodon.dart' as mastodon;
import 'package:fediverse_objects/mastodon_v1.dart' as mastodon_v1;
import 'package:kaiteki_core/model.dart';
import 'package:kaiteki_core_backends/src/mastodon/responses/marker.dart';
import 'package:kaiteki_core/utils.dart';

final mastodonAttachmentTypeRosetta = Rosetta(const {
  'image': AttachmentType.image,
  'video': AttachmentType.video,
  'audio': AttachmentType.audio,
  'gifv': AttachmentType.animated,
  'unknown': AttachmentType.file,
});

final mastodonNotificationTypeMap = const {
  'favourite': NotificationType.liked,
  'reblog': NotificationType.repeated,
  'reaction': NotificationType.reacted,
  'pleroma:emoji_reaction': NotificationType.reacted,
  'follow': NotificationType.followed,
  'mention': NotificationType.mentioned,
  'follow_request': NotificationType.incomingFollowRequest,
  'poll': NotificationType.pollEnded,
  'update': NotificationType.updated,
  'admin.sign_up': NotificationType.signedUp,
  'admin.report': NotificationType.reported,
  'status': NotificationType.newPost,
  'move': NotificationType.userMigrated,
};

final mastodonVisibilityRosetta = Rosetta(const {
  'public': PostScope.public,
  'unlisted': PostScope.unlisted,
  'private': PostScope.followersOnly,
  'direct': PostScope.direct,
  'local': PostScope.local,
});

final pleromaFormattingRosetta = Rosetta(const {
  'text/plain': Formatting.plainText,
  'text/markdown': Formatting.markdown,
  'text/html': Formatting.html,
  'text/bbcode': Formatting.bbCode,
  'text/x.misskeymarkdown': Formatting.misskeyMarkdown,
});

String? _getHost(String acct) {
  final split = acct.split('@');
  if (split.length > 1) return split.last;
  return null;
}

List<MapEntry<String, String>>? _parseFields(Iterable<mastodon.Field>? fields) {
  if (fields == null) return null;
  return fields.map((f) => MapEntry(f.name, f.value)).toList();
}

extension KaitekiMastodonAccountExtension on mastodon.Account {
  User toKaiteki(
    String localHost, {
    mastodon.Relationship? relationship,
  }) {
    UserFollowState? getFollowState() {
      if (relationship?.requested == true) return UserFollowState.pending;

      if (relationship == null) return null;

      return relationship.following == true
          ? UserFollowState.following
          : UserFollowState.notFollowing;
    }

    UserType getUserType() {
      final actorType = source?.pleroma?.actorType;

      if (actorType == 'Organization') return UserType.organization;
      if (actorType == 'Group') return UserType.group;
      if (bot ?? false) return UserType.bot;
      return UserType.person;
    }

    return User(
      source: this,
      displayName: displayName,
      username: username,
      bannerUrl: header.andThen(Uri.parse),
      avatarUrl: avatar.andThen(Uri.parse),
      joinDate: createdAt,
      id: id,
      description: note,
      emojis: emojis.map((e) => e.toKaiteki(localHost)).toList(),
      metrics: UserMetrics(
        followerCount: followersCount,
        followingCount: followingCount,
        postCount: statusesCount,
      ),
      state: UserState(
        isMuted: relationship?.muting,
        isBlocked: relationship?.blocking,
        follow: getFollowState(),
      ),
      host: _getHost(acct) ?? localHost,
      details: UserDetails(fields: _parseFields(fields)),
      url: url.andThen(Uri.parse),
      flags: UserFlags(
        isModerator: pleroma?.isModerator,
        isAdministrator: pleroma?.isAdmin,
        isApprovingFollowers: locked,
      ),
      type: getUserType(),
    );
  }
}

extension KaitekiMastodonAttachmentExtension on mastodon.MediaAttachment {
  Attachment toKaiteki({mastodon.Status? status}) {
    final url = Uri.parse(this.url);
    return Attachment(
      source: this,
      description: description,
      url: url,
      previewUrl: previewUrl.andThen(Uri.parse) ?? url,
      type: mastodonAttachmentTypeRosetta.getRight(type),
      isSensitive: status?.sensitive ?? false,
    );
  }
}

extension KaitekiMastodonEmbedExtension on mastodon.PreviewCard {
  Embed toKaiteki() {
    return Embed(
      source: this,
      uri: url,
      description: description,
      title: title,
      imageUrl: image,
      siteName: providerName,
    );
  }
}

extension KaitekiMastodonEmojiExtension on mastodon.CustomEmoji {
  CustomEmoji toKaiteki(String localHost) {
    return CustomEmoji(
      url: Uri.parse(staticUrl),
      short: shortcode,
      aliases: tags?.toList(),
      instance: localHost,
    );
  }
}

extension KaitekiMastodonInstanceExtension on mastodon.Instance {
  Instance toKaiteki(String host) {
    return Instance(
      source: this,
      name: title,
      description: description,
      backgroundUrl: thumbnail.url,
      administrators: contact.account.andThen((e) => [e.toKaiteki(host)]),
      rules: rules.map((e) => e.text).toList(),
    );
  }
}

extension KaitekiMastodonInstanceV1Extension on mastodon_v1.Instance {
  Instance toKaiteki(String host) {
    return Instance(
      source: this,
      name: title,
      description: description,
      backgroundUrl: thumbnail.andThen(Uri.parse),
      postCount: stats.statusCount,
      userCount: stats.userCount,
      // administrator: instance.contact.andThen(
      //   (e) => toUser(e, host),
      // ),
    );
  }
}

extension KaitekiMastodonListExtension on mastodon.List {
  PostList toKaiteki() => PostList(source: this, id: id, name: title);
}

extension KaitekiMastodonNotificationExtension on mastodon.Notification {
  Notification toKaiteki(String localHost, [Marker? marker]) {
    final bool? unread;

    if (marker != null) {
      final lastReadId = int.tryParse(marker.lastReadId);
      final numericId = int.tryParse(id);

      if (lastReadId == null || numericId == null) {
        unread = null;
      } else {
        unread = numericId > lastReadId;
      }
    } else if (pleroma != null) {
      unread = !pleroma!.isSeen;
    } else {
      unread = null;
    }

    return Notification(
      id: id,
      createdAt: createdAt,
      type: mastodonNotificationTypeMap[type]!,
      user: account.andThen((e) => e.toKaiteki(localHost)),
      post: status.andThen((e) => e.toKaiteki(localHost)),
      unread: unread,
    );
  }
}

extension KaitekiMastodonPollExtension on mastodon.Poll {
  Poll toKaiteki() {
    return Poll(
      id: id,
      hasEnded: expired,
      endsAt: expiresAt ?? DateTime.now(),
      source: this,
      options: options.map((o) => PollOption(o.title, o.votesCount)).toList(),
      hasVoted: voted ?? false,
      voteCount: votesCount,
      voterCount: votersCount,
      allowMultipleChoices: multiple,
    );
  }
}

extension KaitekiMastodonReactionExtension on mastodon.Reaction {
  Reaction toKaiteki(String localHost) {
    final url = this.url;
    final emoji = url != null
        ? CustomEmoji.parse(name, url, localHost)
        : UnicodeEmoji(name);

    return Reaction(
      includesMe: me,
      count: count,
      emoji: emoji,
      users: accounts?.map((a) => a.toKaiteki(localHost)).toList() ?? [],
    );
  }
}

extension KaitekiMastodonStatusExtension on mastodon.Status {
  Post toKaiteki(String localHost) {
    Iterable<Reaction> getReactions() {
      final r = reactions ?? pleroma?.emojiReactions;
      return r?.map((e) => e.toKaiteki(localHost)).toList() ?? const [];
    }

    User? getRepliedUser() {
      if (inReplyToAccountId == null) return null;

      final mention = mentions.firstWhereOrNull((mention) {
        return mention.id == inReplyToAccountId;
      });

      if (mention == null) return null;

      return User(
        host: _getHost(mention.account) ?? localHost,
        username: mention.username,
        id: mention.id,
        displayName: mention.username,
        source: mention,
      );
    }

    final repliedUser = getRepliedUser();
    return Post(
      content: content,
      postedAt: createdAt,
      nsfw: sensitive,
      subject: spoilerText,
      author: account.toKaiteki(localHost),
      repeatOf: reblog.andThen((e) => e.toKaiteki(localHost)),
      emojis: emojis.map((e) => e.toKaiteki(localHost)).toList(),
      attachments:
          mediaAttachments.map((e) => e.toKaiteki(status: this)).toList(),
      visibility: mastodonVisibilityRosetta.getRight(visibility),
      replyTo: inReplyToId.andThen(ResolvablePost.fromId),
      replyToUser: repliedUser == null
          ? inReplyToAccountId.andThen(ResolvableUser.fromId)
          : ResolvableUser.fromData(repliedUser),
      id: id,
      // FIXME(Craftplacer): url should be Uri?, not String?
      externalUrl: url.andThen(Uri.parse),
      client: application?.name,
      reactions: getReactions().toList(),
      language: language,
      mentionedUsers: mentions.map((e) {
        return UserReference.all(
          username: e.username,
          id: e.id,
          remoteUrl: e.url,
          host: _getHost(e.account),
        );
      }).toList(growable: false),
      metrics: PostMetrics(
        favoriteCount: favouritesCount,
        repeatCount: reblogsCount,
        replyCount: repliesCount,
      ),
      state: PostState(
        // shouldn't be null because we currently expect the user to be signed in
        repeated: reblogged ?? false,
        favorited: favourited ?? false,
        bookmarked: bookmarked ?? false,
        pinned: pinned ?? false,
      ),
      poll: poll.andThen((e) => e.toKaiteki()),
      embeds: card.andThen((e) => [e.toKaiteki()]) ?? const [],
      quotedPost: quote.andThen((e) => e.toKaiteki(localHost)),
      threadId: pleroma?.context,
    );
  }
}

extension KaitekiMastodonAnnouncementExtension on mastodon.Announcement {
  Announcement toKaiteki(String host) {
    return Announcement(
      id: id,
      content: content,
      createdAt: createdAt,
      updatedAt: updatedAt,
      important: null,
      isUnread: read.andThen((e) => !e),
    );
  }
}

extension KaitekiMastodonTagExtension on mastodon.Tag {
  Hashtag toKaiteki() {
    return Hashtag(
      name,
      isFollowing: following,
    );
  }
}
