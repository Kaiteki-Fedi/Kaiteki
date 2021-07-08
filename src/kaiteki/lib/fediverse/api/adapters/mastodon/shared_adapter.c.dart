part of 'shared_adapter.dart';

Post toPost(MastodonStatus source) {
  return Post(
    source: source,
    content: source.content,
    postedAt: source.createdAt,
    nsfw: source.sensitive,
    subject: source.spoilerText,
    author: toUser(source.account),
    repeatOf: source.reblog != null ? toPost(source.reblog!) : null,
    // shouldn't be null because we currently expect the user to be signed in
    repeated: source.reblogged!,
    liked: source.favourited!,
    emojis: source.emojis.map(toEmoji),
    attachments: source.mediaAttachments.map(toAttachment),
    likeCount: source.favouritesCount,
    repeatCount: source.reblogsCount,
    replyCount: source.repliesCount,
    visibility: toVisibility(source.visibility),
    replyToAccountId: source.inReplyToAccountId,
    replyToPostId: source.inReplyToId,
    id: source.id,
    externalUrl: source.url,
    reactions: [], // TODO: add pleroma reactions?
  );
}

Visibility toVisibility(String visibility) {
  switch (visibility) {
    case 'public':
      return Visibility.public;
    case 'private':
      return Visibility.followersOnly;
    case 'direct':
      return Visibility.direct;
    case 'unlisted':
      return Visibility.unlisted;
    default:
      throw 'Unknown visibility $visibility.';
  }
}

Attachment toAttachment(MastodonAttachment attachment) {
  return Attachment(
    source: attachment,
    description: attachment.description,
    url: attachment.url,
    previewUrl: attachment.previewUrl,
    type: toAttachmentType(attachment.type),
  );
}

AttachmentType toAttachmentType(String type) {
  switch (type) {
    case 'image':
      return AttachmentType.image;
    // case 'gifv': return AttachmentType.animated;
    case 'video':
      return AttachmentType.video;
    case 'audio':
      return AttachmentType.audio;
    default:
      return AttachmentType.file;
  }
}

CustomEmoji toEmoji(MastodonEmoji emoji) {
  return CustomEmoji(
    source: emoji,
    url: emoji.staticUrl,
    name: emoji.shortcode,
    aliases: emoji.tags ?? [],
  );
}

User toUser(MastodonAccount source) {
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
    birthday: null, // Mastodon doesn't support this
    followerCount: source.followersCount,
    followingCount: source.followingCount,
    postCount: source.statusesCount,
    host: getHost(source.acct),
  );
}

String? getHost(String acct) {
  var split = acct.split('@');

  if (split.length > 1) return split.last;

  return null;
}
