part of "shared_adapter.dart";

final mastodonVisibilityRosetta = Rosetta(const {
  "public": Visibility.public,
  "unlisted": Visibility.unlisted,
  "private": Visibility.followersOnly,
  "direct": Visibility.direct,
  "local": Visibility.local,
});

final mastodonNotificationTypeRosetta = Rosetta(const {
  "favourite": NotificationType.liked,
  "reblog": NotificationType.repeated,
  "pleroma:emoji_reaction": NotificationType.reacted,
  "follow": NotificationType.followed,
  "mention": NotificationType.mentioned,
  "follow_request": NotificationType.followRequest,
  "poll": NotificationType.pollEnded,
  "update": NotificationType.updated,
  "admin.sign_up": NotificationType.signedUp,
  "admin.report": NotificationType.reported,
  "status": NotificationType.newPost,
});

final mastodonAttachmentTypeRosetta = Rosetta(const {
  "image": AttachmentType.image,
  "video": AttachmentType.video,
  "audio": AttachmentType.audio,
  "gifv": AttachmentType.animated,
});

final pleromaFormattingRosetta = Rosetta(const {
  "text/plain": Formatting.plainText,
  "text/markdown": Formatting.markdown,
  "text/html": Formatting.html,
  "text/bbcode": Formatting.bbCode,
});

Post toPost(mastodon.Status source, String localHost) {
  final repliedUser = getRepliedUser(source, localHost);
  return Post(
    source: source,
    content: source.content,
    postedAt: source.createdAt,
    nsfw: source.sensitive,
    subject: source.spoilerText,
    author: toUser(source.account, localHost),
    repeatOf: source.reblog.nullTransform((r) => toPost(r, localHost)),
    emojis: source.emojis.map(toEmoji).toList(),
    attachments: source.mediaAttachments
        .map((a) => toAttachment(a, status: source))
        .toList(),
    visibility: mastodonVisibilityRosetta.getRight(source.visibility),
    replyTo: source.inReplyToId.nullTransform(ResolvablePost.fromId),
    replyToUser: repliedUser == null
        ? source.inReplyToAccountId.nullTransform(ResolvableUser.fromId)
        : ResolvableUser.fromData(repliedUser),
    id: source.id,
    // FIXME(Craftplacer): source.url should be Uri?, not String?
    externalUrl: source.url.nullTransform(Uri.parse),
    client: source.application?.name,
    reactions: source.pleroma?.emojiReactions
            ?.map((r) => toReaction(r, localHost))
            .toList() ??
        const [],
    mentionedUsers: source.mentions.map((e) {
      return UserReference.all(
        username: e.username,
        id: e.id,
        remoteUrl: e.url,
        host: _getHost(e.account),
      );
    }).toList(growable: false),
    metrics: PostMetrics(
      favoriteCount: source.favouritesCount,
      repeatCount: source.reblogsCount,
      replyCount: source.repliesCount,
    ),
    state: PostState(
      // shouldn't be null because we currently expect the user to be signed in
      repeated: source.reblogged ?? false,
      favorited: source.favourited ?? false,
      bookmarked: source.bookmarked ?? false,
      pinned: source.pinned ?? false,
    ),
    poll: source.poll.nullTransform(toPoll),
  );
}

Poll toPoll(mastodon.Poll poll) {
  return Poll(
    id: poll.id,
    hasEnded: poll.expired,
    endedAt: poll.expiresAt!,
    source: poll,
    options: poll.options
        .map(
          (o) => PollOption(o.title, o.votesCount),
        )
        .toList(),
    hasVoted: poll.voted ?? false,
    voteCount: poll.votesCount,
    voterCount: poll.votersCount,
    allowMultipleChoices: poll.multiple,
  );
}

Notification toNotification(
  mastodon.Notification notification,
  String localHost, [
  Marker? marker,
]) {
  final bool? unread;

  if (marker != null) {
    final lastReadId = int.tryParse(marker.lastReadId);
    final id = int.tryParse(notification.id);

    if (lastReadId == null || id == null) {
      unread = null;
    } else {
      unread = id > lastReadId;
    }
  } else if (notification.pleroma != null) {
    unread = !notification.pleroma!.isSeen;
  } else {
    unread = null;
  }

  return Notification(
    createdAt: notification.createdAt,
    type: mastodonNotificationTypeRosetta.getRight(notification.type),
    user: notification.account.nullTransform((u) => toUser(u, localHost)),
    post: notification.status.nullTransform((p) => toPost(p, localHost)),
    unread: unread,
  );
}

Reaction toReaction(pleroma.EmojiReaction reaction, String localHost) {
  return Reaction(
    includesMe: reaction.me,
    count: reaction.count,
    emoji: UnicodeEmoji(reaction.name),
    users: reaction.accounts?.map((a) => toUser(a, localHost)).toList() ?? [],
  );
}

User? getRepliedUser(mastodon.Status status, String localHost) {
  if (status.inReplyToAccountId == null) return null;

  final mention = status.mentions.firstWhereOrNull((mention) {
    return mention.id == status.inReplyToAccountId;
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

Attachment toAttachment(
  mastodon.Attachment attachment, {
  mastodon.Status? status,
}) {
  return Attachment(
    source: attachment,
    description: attachment.description,
    url: attachment.url,
    previewUrl: attachment.previewUrl ?? attachment.url,
    type: mastodonAttachmentTypeRosetta.getRight(attachment.type),
    isSensitive: status?.sensitive ?? false,
  );
}

CustomEmoji toEmoji(mastodon.Emoji emoji) {
  return CustomEmoji(
    url: Uri.parse(emoji.staticUrl),
    short: emoji.shortcode,
    aliases: emoji.tags?.toList(),
  );
}

User toUser(mastodon.Account source, String localHost) {
  return User(
    source: source,
    displayName: source.displayName,
    username: source.username,
    bannerUrl: source.header,
    avatarUrl: source.avatar,
    joinDate: source.createdAt,
    id: source.id,
    description: source.note,
    emojis: source.emojis.map(toEmoji).toList(),
    followerCount: source.followersCount,
    followingCount: source.followingCount,
    postCount: source.statusesCount,
    host: _getHost(source.acct) ?? localHost,
    details: UserDetails(fields: _parseFields(source.fields)),
    url: source.url.nullTransform(Uri.parse),
    flags: UserFlags(
      isBot: source.bot ?? false,
      isModerator: source.pleroma?.isModerator ?? false,
      isAdministrator: source.pleroma?.isAdmin ?? false,
      isApprovingFollowers: source.locked,
    ),
  );
}

Map<String, String>? _parseFields(Iterable<mastodon.Field>? fields) {
  if (fields == null) {
    return null;
  } else {
    final entries = fields.map((f) => MapEntry(f.name, f.value));
    return Map<String, String>.fromEntries(entries);
  }
}

String? _getHost(String acct) {
  final split = acct.split("@");
  if (split.length > 1) return split.last;
  return null;
}

Instance toInstance(mastodon.Instance instance) {
  return Instance(
    source: instance,
    name: instance.title,
    backgroundUrl: instance.thumbnail,
  );
}

PostList toList(mastodon.List list) {
  return PostList(source: list, id: list.id, name: list.title);
}
