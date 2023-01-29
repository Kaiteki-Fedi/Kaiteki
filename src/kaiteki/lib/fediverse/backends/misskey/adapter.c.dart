part of "adapter.dart";

final misskeyNotificationTypeRosetta = Rosetta(const {
  misskey.NotificationType.follow: NotificationType.followed,
  misskey.NotificationType.mention: NotificationType.mentioned,
  misskey.NotificationType.reply: NotificationType.replied,
  misskey.NotificationType.renote: NotificationType.repeated,
  misskey.NotificationType.quote: NotificationType.quoted,
  misskey.NotificationType.reaction: NotificationType.reacted,
  misskey.NotificationType.pollEnded: NotificationType.pollEnded,
  misskey.NotificationType.receiveFollowRequest: NotificationType.followRequest,
  misskey.NotificationType.followRequestAccepted: NotificationType.followed,
  misskey.NotificationType.groupInvited: NotificationType.groupInvite,
  misskey.NotificationType.achievementEarned: NotificationType.unsupported,
});

final misskeyVisibilityRosetta = Rosetta<String, Visibility>(const {
  "specified": Visibility.direct,
  "followers": Visibility.followersOnly,
  "home": Visibility.unlisted,
  "public": Visibility.public,
});

Post toPost(misskey.Note source, String localHost) {
  final mappedEmoji = source.emojis?.map<CustomEmoji>(toEmoji).toList();
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
      final Emoji emoji;

      if (mappedEmoji != null) {
        emoji = getEmojiFromString(mkr.key, mappedEmoji);
      } else if (isCustomEmoji(mkr.key)) {
        final emojiName = mkr.key.substring(1, mkr.key.length - 1);
        final emojiUrl = buildEmojiUri(localHost, emojiName);
        emoji = CustomEmoji(short: mkr.key, url: emojiUrl);
      } else {
        emoji = UnicodeEmoji(mkr.key);
      }

      return Reaction(
        count: mkr.value,
        includesMe: mkr.key == source.myReaction,
        emoji: emoji,
      );
    }).toList(),
    replyTo: replyTo,
    repeatOf: source.renote.nullTransform((n) => toPost(n, localHost)),
    id: source.id,
    visibility: misskeyVisibilityRosetta.getRight(source.visibility),
    attachments: source.files?.map(toAttachment).toList(),
    // FIXME(Craftplacer): Change to Uri?
    externalUrl: source.url.nullTransform(Uri.parse),
    metrics: PostMetrics(
      repeatCount: source.renoteCount,
      replyCount: source.repliesCount,
    ),
  );
}

bool isCustomEmoji(String input) =>
    input.length >= 3 && input.startsWith(":") && input.endsWith(":");

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
    url: Uri.parse(emoji.url),
    aliases: emoji.aliases,
  );
}

User toUser(misskey.User source, String localHost) {
  return User(
    avatarUrl: source.avatarUrl,
    avatarBlurHash: source.avatarBlurhash as String?,
    bannerUrl: source.bannerUrl,
    bannerBlurHash: source.bannerBlurhash as String?,
    description: source.description,
    displayName: source.name,
    emojis: source.emojis?.map(toEmoji).toList(),
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
    emojis: source.emojis?.map(toEmoji).toList(),
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

Map<String, String>? _parseFields(Iterable<JsonMap>? fields) {
  if (fields == null) return null;

  return Map<String, String>.fromEntries(
    fields.map(
      (e) => MapEntry(
        e["name"] as String,
        e["value"] as String,
      ),
    ),
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
    iconUrl: instance.iconUrl
        .nullTransform((e) => instanceUri.resolve(e).toString()),
    mascotUrl: instance.mascotImageUrl
        .nullTransform((e) => instanceUri.resolve(e).toString()),
    backgroundUrl: instance.bannerUrl,
    source: instance,
  );
}

ChatMessage toChatMessage(misskey.MessagingMessage message, String localHost) {
  final file = message.file;
  return ChatMessage(
    author: toUserFromLite(message.user!, localHost),
    content: message.text,
    sentAt: message.createdAt,
    emojis: [],
    attachments: [if (file != null) toAttachment(file)],
  );
}

Notification toNotification(
  misskey.Notification notification,
  String localHost,
) {
  final note = notification.note;
  final user = notification.user;

  return Notification(
    createdAt: notification.createdAt,
    type: misskeyNotificationTypeRosetta.getRight(notification.type),
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

Uri buildEmojiUri(String localHost, String emoji) {
  assert(!(emoji.startsWith(":") || emoji.endsWith(":")));
  final emojiSplit = emoji.split("@");
  return Uri(
    scheme: "https",
    host: localHost,
    pathSegments: [
      "emoji",
      if (emojiSplit.length == 1 || emojiSplit[1] == ".")
        "${emojiSplit[0]}.webp"
      else
        "$emoji.webp",
    ],
  );
}

Uri buildEmojiUriManual(String localHost, String name, String? remoteHost) {
  return Uri(
    scheme: "https",
    host: localHost,
    pathSegments: [
      "emoji",
      if (remoteHost == null) "$name.webp" else "$name@$remoteHost.webp",
    ],
  );
}
