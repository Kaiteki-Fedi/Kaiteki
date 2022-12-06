part of 'adapter.dart';

Post toPost(misskey.Note source, String localHost) {
  final mappedEmoji = source.emojis.map<CustomEmoji>(toEmoji).toList();

  return Post(
    source: source,
    postedAt: source.createdAt,
    author: toUserFromLite(source.user, localHost),
    content: source.text,
    emojis: mappedEmoji,
    reactions: source.reactions.entries.map((mkr) {
      return Reaction(
        count: mkr.value,
        includesMe: mkr.key == source.myReaction,
        users: [],
        emoji: getEmojiFromString(mkr.key, mappedEmoji),
      );
    }).toList(),
    replyTo: source.reply == null ? null : toPost(source.reply!, localHost),
    replyToPostId: source.replyId,
    repeatOf: source.renote == null ? null : toPost(source.renote!, localHost),
    id: source.id,
    visibility: toVisibility(source.visibility),
    attachments: source.files?.map(toAttachment).toList(),
    externalUrl: source.url == null ? null : Uri.parse(source.url!),
    metrics: PostMetrics(
      repeatCount: source.renoteCount,
      replyCount: source.repliesCount,
    ),
  );
}

Emoji getEmojiFromString(String key, Iterable<CustomEmoji> mappedEmoji) {
  final emoji = mappedEmoji.firstOrDefault(
    (e) {
      if (key.length < 3) return false;
      final emojiName = key.substring(1, key.length - 1);
      return e.short == emojiName;
    },
  );

  if (emoji == null) return UnicodeEmoji(key);

  return emoji;
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
    short: emoji.name,
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

Notification toNotification(
  misskey.Notification notification,
  String localHost,
) {
  final type = const {
    misskey.NotificationType.follow: NotificationType.followed,
    misskey.NotificationType.mention: NotificationType.mentioned,
    misskey.NotificationType.reply: NotificationType.replied,
    misskey.NotificationType.renote: NotificationType.repeated,
    misskey.NotificationType.quote: NotificationType.quoted,
    misskey.NotificationType.reaction: NotificationType.reacted,
    misskey.NotificationType.pollEnded: NotificationType.pollEnded,
    misskey.NotificationType.receiveFollowRequest:
        NotificationType.followRequest,
    misskey.NotificationType.followRequestAccepted: NotificationType.followed,
    misskey.NotificationType.groupInvited: NotificationType.groupInvite,
  }[notification.type];

  if (type == null) {
    throw UnsupportedError(
      "Kaiteki does not support ${notification.type} as notification type",
    );
  }

  final note = notification.note;
  final user = notification.user;

  return Notification(
    createdAt: notification.createdAt,
    type: type,
    user: user == null ? null : toUserFromLite(user, localHost),
    post: note == null ? null : toPost(note, localHost),
    unread: !notification.isRead,
  );
}
