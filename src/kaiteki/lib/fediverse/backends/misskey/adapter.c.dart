part of 'adapter.dart';

Post toPost(misskey.Note source, String localHost) {
  final mappedEmoji = source.emojis.map<CustomEmoji>(toEmoji).toList();

  return Post(
    source: source,
    postedAt: source.createdAt,
    author: toUserFromLite(source.user, localHost),
    content: source.text,
    emojis: mappedEmoji,
    // FIXME(Craftplacer): I give up
    // reactions: source.reactions.map((mkr) {
    //   return Reaction(
    //     count: mkr.value,
    //     includesMe: mkr.key == source.myReaction,
    //     users: [],
    //     emoji: getEmojiFromString(mkr.key, mappedEmoji),
    //   );
    // }),
    replyTo: source.reply == null ? null : toPost(source.reply!, localHost),
    replyToPostId: source.replyId,
    repeatOf: source.renote == null ? null : toPost(source.renote!, localHost),
    id: source.id,
    visibility: toVisibility(source.visibility),
    attachments: source.files?.map(toAttachment).toList(),
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

CustomEmoji toEmoji(misskey.Emoji emoji) {
  return CustomEmoji(
    source: emoji,
    name: emoji.name,
    url: emoji.url,
    aliases: emoji.aliases,
  );
}

User toUser(misskey.User source, String localHost) {
  return User(
    avatarUrl: source.avatarUrl,
    bannerUrl: source.bannerUrl,
    description: source.description,
    displayName: source.name,
    emojis: source.emojis.map(toEmoji),
    host: source.host ?? localHost,
    id: source.id,
    joinDate: source.createdAt,
    source: source,
    username: source.username,
    details: UserDetails(
      location: source.location,
      birthday: _parseBirthday(source.birthday),
      fields: _parseFields(source.fields),
    ),
  );
}

User toUserFromLite(misskey.UserLite source, String localHost) {
  return User(
    avatarUrl: source.avatarUrl,
    // FIXME(Craftplacer): Adapters shouldn't "guess" values, e.g. display name inherited by username.
    displayName: source.name ?? source.username,
    emojis: source.emojis.map(toEmoji),
    host: source.host ?? localHost,
    id: source.id,
    source: source,
    username: source.username,
    flags: UserFlags(
      isAdministrator: source.isAdmin ?? false,
      isModerator: source.isModerator ?? false,
      isApprovingFollowers: false,
      isBot: source.isBot ?? false,
    ),
  );
}

Map<String, String>? _parseFields(Iterable<Map<String, dynamic>>? fields) {
  if (fields == null) {
    return null;
  }

  return Map<String, String>.fromEntries(
    fields.map((o) => MapEntry(o["name"], o["value"])),
  );
}

DateTime? _parseBirthday(String? birthday) {
  if (birthday == null) {
    return null;
  }

  final dateFormat = DateFormat("yyyy-MM-dd");
  return dateFormat.parseStrict(birthday);
}

Instance toInstance(misskey.Meta instance, String instanceUrl) {
  final instanceUri = Uri.parse(instanceUrl);

  return Instance(
    name: instance.name,
    iconUrl: instance.iconUrl == null
        ? null
        : instanceUri.resolve(instance.iconUrl!).toString(),
    mascotUrl: instanceUri.resolve(instance.mascotImageUrl).toString(),
    backgroundUrl: instance.bannerUrl,
    source: instance,
  );
}
