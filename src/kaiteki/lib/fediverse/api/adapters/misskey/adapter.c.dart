part of 'adapter.dart';

Post toPost(misskey.Note source) {
  var mappedEmoji = source.emojis.map(toEmoji);

  return Post(
    source: source,
    postedAt: source.createdAt,
    author: toUser(source.user),
    liked: false,
    repeated: false,
    content: source.text,
    emojis: mappedEmoji,
    replyCount: 0,
    likeCount: 0,
    repeatCount: 0,
    reactions: source.reactions.entries.map((mkr) {
      return Reaction(
        count: mkr.value,
        includesMe: mkr.key == source.myReaction,
        users: [],
        emoji: getEmojiFromString(mkr.key, mappedEmoji),
      );
    }),
    replyToPostId: source.replyId,
    id: source.id,
    visibility: toVisibility(source.visibility),
    attachments: source.files?.map(toAttachment) ?? [],
  );
}

Visibility toVisibility(String visibility) {
  switch (visibility) {
    case "public":
      return Visibility.public;
    case "home":
      return Visibility.unlisted;
    case "followers":
      return Visibility.followersOnly;
    case "specified":
      return Visibility.direct;

    default:
      throw Exception("Missing case for $visibility");
  }
}

Attachment toAttachment(misskey.DriveFile file) {
  return Attachment(
    source: file,
    description: file.name,
    previewUrl: file.thumbnailUrl ?? file.url!,
    url: file.url!,
  );
}

Emoji getEmojiFromString(String emojiString, Iterable<Emoji> inheritingEmoji) {
  if (emojiString.startsWith(":") && emojiString.endsWith(":")) {
    var matchingEmoji = inheritingEmoji.firstWhere(
        (e) => e.name == emojiString.substring(1, emojiString.length - 1));

    return matchingEmoji;
  }

  return UnicodeEmoji(emojiString, "", aliases: null);
}

CustomEmoji toEmoji(misskey.Emoji emoji) {
  return CustomEmoji(
    source: emoji,
    name: emoji.name,
    url: emoji.url,
    aliases: emoji.aliases,
  );
}

User toUser(misskey.User source) {
  return User(
    source: source,
    username: source.username,
    displayName: source.name ?? source.username,
    joinDate: source.createdAt,
    emojis: source.emojis.map(toEmoji),
    avatarUrl: source.avatarUrl,
    bannerUrl: source.bannerUrl,
    id: source.id,
    description: source.description,
    host: source.host,
  );
}

Instance toInstance(misskey.Meta instance, String instanceUrl) {
  final instanceUri = Uri.parse(instanceUrl);

  return Instance(
    name: instance.name,
    iconUrl: instance.iconUrl == null
        ? null
        : instanceUri.resolve(instance.iconUrl!).toString(),
    mascotUrl: instanceUri.resolve(instance.mascotImageUrl).toString(),
    backgroundUrl: instance.backgroundImageUrl == null
        ? null
        : instanceUri.resolve(instance.backgroundImageUrl!).toString(),
    source: instance,
  );
}
