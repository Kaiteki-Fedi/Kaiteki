part of 'pleroma_adapter.dart';

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

// TODO
ChatMessage toChatMessage(PleromaChatMessage message) => throw UnimplementedError();