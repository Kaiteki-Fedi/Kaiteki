part of 'shared_mastodon_adapter.dart';

Post toPost(MastodonStatus source) {
  if (source == null) return null;

  return Post(
    source: source,
    content: source.content,
    postedAt: source.createdAt,
    nsfw: source.sensitive,
    subject: source.spoilerText,
    author: toUser(source.account),
    repeatOf: toPost(source.reblog),
    repeated: source.reblogged,
    liked: source.favourited,
    emojis: source.emojis.map(toEmoji),
    attachments: source.mediaAttachments.map(toAttachment),
    likeCount: source.favouritesCount,
    repeatCount: source.reblogsCount,
  );
}

Attachment toAttachment(MastodonMediaAttachment attachment) {
  return Attachment(
    source: attachment,
    description: attachment.description,
    url: attachment.url,
    previewUrl: attachment.previewUrl,
    type: attachment.type,
  );
}

CustomEmoji toEmoji(MastodonEmoji emoji) {
  return CustomEmoji(
    source: emoji,
    url: emoji.staticUrl,
    name: emoji.shortcode,
    aliases: emoji.tags,
  );
}

User toUser(MastodonAccount source) {
  if (source == null) return null;

  return User(
    source: source,
    displayName: source.displayName,
    username: source.username,
    bannerUrl: source.header,
    avatarUrl: source.avatar,
    joinDate: source.createdAt,
    id: source.id,
  );
}
