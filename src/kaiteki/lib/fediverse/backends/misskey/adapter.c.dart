part of 'adapter.dart';

Post toPost(misskey.Note source, String localHost) {
  final mappedEmoji = source.emojis.map<CustomEmoji>(toEmoji).toList();
  final sourceReply = source.reply;
  final sourceReplyId = source.replyId;

  ResolvablePost? replyTo;
  if (sourceReplyId != null) {
    replyTo = sourceReply == null
        ? ResolvablePost.fromId(sourceReplyId)
        : toPost(sourceReply, localHost).resolved;
  }

  return Post(
    source: source,
    postedAt: source.createdAt,
    author: toUserFromLite(source.user, localHost),
    subject: source.cw,
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
    replyTo: replyTo,
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

Emoji getEmojiFromString(String key, List<CustomEmoji> mappedEmoji) {
  final emoji = mappedEmoji.firstWhereOrNull(
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

  final mainType = file.type.split("/").first.toLowerCase();
  switch (mainType) {
    case "video":
      type = AttachmentType.video;
      break;
    case "image":
      type = AttachmentType.image;
      break;
    case "audio":
      type = AttachmentType.audio;
      break;
  }

  return Attachment(
    source: file,
    description: file.name,
    previewUrl: file.thumbnailUrl ?? file.url!,
    url: file.url!,
    type: type,
    isSensitive: file.isSensitive,
    blurHash: file.blurhash,
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
    avatarBlurHash: source.avatarBlurhash,
    bannerUrl: source.bannerUrl,
    bannerBlurHash: source.bannerBlurhash,
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
    followerCount: source.followersCount,
    followingCount: source.followingCount,
    postCount: source.notesCount,
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
    mascotUrl: instance.mascotImageUrl == null
        ? null
        : instanceUri.resolve(instance.mascotImageUrl!).toString(),
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

PostList toList(MisskeyList list) {
  return PostList(
    id: list.id,
    name: list.name,
    createdAt: list.createdAt,
    source: list.createdAt,
  );
}
