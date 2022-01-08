part of 'adapter.dart';

Post toPost(misskey.Note source) {
  final mappedEmoji = source.emojis.map(toEmoji);

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
    replyTo: source.reply == null ? null : toPost(source.reply!),
    replyToPostId: source.replyId,
    repeatOf: source.renote == null ? null : toPost(source.renote!),
    id: source.id,
    visibility: toVisibility(source.visibility),
    attachments: source.files?.map(toAttachment) ?? [],
    externalUrl: source.url,
  );
}

Visibility toVisibility(String visibility) {
  const stringToVisibility = {
    "public": Visibility.public,
    "home": Visibility.unlisted,
    "followers": Visibility.followersOnly,
    "specified": Visibility.direct,
  };

  return stringToVisibility[visibility]!;
}

Attachment toAttachment(misskey.DriveFile file) {
  var type = AttachmentType.file;

  if (file.type.startsWith("image/")) {
    type = AttachmentType.image;
  }

  return Attachment(
    source: file,
    description: file.name,
    previewUrl: file.thumbnailUrl ?? file.url!,
    url: file.url!,
    type: type,
  );
}

Emoji getEmojiFromString(String emojiString, Iterable<Emoji> inheritingEmoji) {
  if (emojiString.startsWith(":") && emojiString.endsWith(":")) {
    final matchingEmoji = inheritingEmoji.firstWhere(
      (e) => e.name == emojiString.substring(1, emojiString.length - 1),
    );

    return matchingEmoji;
  }

  return UnicodeEmoji(emojiString, "");
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
    fields: _parseFields(source.fields),
    host: source.host,

Map<String, String>? _parseFields(Iterable<Map<String, dynamic>>? fields) {
  if (fields == null) {
    return null;
  }

  Map<String, String>.fromEntries(
    fields.map((o) => MapEntry(o["name"], o["value"])),
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
