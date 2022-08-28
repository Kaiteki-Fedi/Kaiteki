part of 'shared_adapter.dart';

Post toPost(mastodon.Status source) {
  return Post(
    source: source,
    content: source.content,
    postedAt: source.createdAt,
    nsfw: source.sensitive,
    subject: source.spoilerText,
    author: toUser(source.account),
    bookmarked: source.bookmarked ?? false,
    repeatOf: source.reblog != null ? toPost(source.reblog!) : null,
    // shouldn't be null because we currently expect the user to be signed in
    repeated: source.reblogged!,
    liked: source.favourited!,
    emojis: source.emojis.map(toEmoji),
    attachments: source.mediaAttachments.map(
      (a) => toAttachment(a, status: source),
    ),
    pinned: source.pinned ?? false,
    likeCount: source.favouritesCount,
    repeatCount: source.reblogsCount,
    replyCount: source.repliesCount,
    visibility: toVisibility(source.visibility),
    replyToUserId: source.inReplyToAccountId,
    replyToPostId: source.inReplyToId,
    replyToUser: getRepliedUser(source),
    id: source.id,
    externalUrl: source.url,
    reactions: source.pleroma?.emojiReactions?.map(toReaction) ?? [],
    mentionedUsers: source.mentions.map((e) {
      return UserReference.all(
        username: e.username,
        id: e.id,
        remoteUrl: e.url,
        host: getHost(e.account),
      );
    }).toList(growable: false),
  );
}

Reaction toReaction(pleroma.EmojiReaction reaction) {
  return Reaction(
    includesMe: reaction.me,
    count: reaction.count,
    emoji: UnicodeEmoji(reaction.name, ""),
    users: reaction.accounts?.map(toUser) ?? [],
  );
}

User? getRepliedUser(mastodon.Status status) {
  final mention = status.mentions.firstOrDefault((mention) {
    return mention.id == status.inReplyToAccountId;
  });

  if (mention == null) {
    return null;
  }

  return User(
    host: getHost(mention.account),
    username: mention.username,
    id: mention.id,
    displayName: mention.username,
    source: mention,
  );
}

Visibility toVisibility(String visibility) {
  const visibilityToString = {
    'public': Visibility.public,
    'private': Visibility.followersOnly,
    'direct': Visibility.direct,
    'unlisted': Visibility.unlisted,
  };

  return visibilityToString[visibility]!;
}

Attachment toAttachment(
  mastodon.Attachment attachment, {
  mastodon.Status? status,
}) {
  return Attachment(
    source: attachment,
    description: attachment.description,
    url: attachment.url,
    previewUrl: attachment.previewUrl!,
    type: toAttachmentType(attachment.type),
    isSensitive: status?.sensitive ?? false,
  );
}

AttachmentType toAttachmentType(String type) {
  const attachmentTypeToString = {
    'image': AttachmentType.image,
    'video': AttachmentType.video,
    'audio': AttachmentType.audio,
    // 'gifv': AttachmentType.animated,
  };

  return attachmentTypeToString[type] ?? AttachmentType.file;
}

CustomEmoji toEmoji(mastodon.Emoji emoji) {
  return CustomEmoji(
    source: emoji,
    url: emoji.staticUrl,
    name: emoji.shortcode,
    aliases: emoji.tags ?? [],
  );
}

User toUser(mastodon.Account source) {
  return User(
    source: source,
    displayName: source.displayName,
    username: source.username,
    bannerUrl: source.header,
    avatarUrl: source.avatar,
    joinDate: source.createdAt,
    id: source.id,
    description: source.note,
    emojis: source.emojis.map(toEmoji),
    followerCount: source.followersCount,
    followingCount: source.followingCount,
    postCount: source.statusesCount,
    host: getHost(source.acct),
    details: UserDetails(fields: _parseFields(source.fields)),
    url: source.url,
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

String? getHost(String acct) {
  final split = acct.split('@');

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
