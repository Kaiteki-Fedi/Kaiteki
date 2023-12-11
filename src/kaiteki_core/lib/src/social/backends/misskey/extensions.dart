import 'package:collection/collection.dart';
import 'package:fediverse_objects/misskey.dart' as misskey;
import 'package:intl/intl.dart';
import 'package:kaiteki_core/social.dart';
import 'package:kaiteki_core/src/social/backends/misskey/model/list.dart';
import 'package:kaiteki_core/utils.dart';

final misskeyNotificationTypeRosetta = {
  misskey.NotificationType.follow: NotificationType.followed,
  misskey.NotificationType.mention: NotificationType.mentioned,
  misskey.NotificationType.reply: NotificationType.replied,
  misskey.NotificationType.renote: NotificationType.repeated,
  misskey.NotificationType.quote: NotificationType.quoted,
  misskey.NotificationType.reaction: NotificationType.reacted,
  misskey.NotificationType.pollEnded: NotificationType.pollEnded,
  misskey.NotificationType.pollVote: NotificationType.unsupported,
  misskey.NotificationType.receiveFollowRequest:
      NotificationType.incomingFollowRequest,
  misskey.NotificationType.followRequestAccepted:
      NotificationType.outgoingFollowRequestAccepted,
  misskey.NotificationType.groupInvited: NotificationType.groupInvite,
  misskey.NotificationType.achievementEarned: NotificationType.unsupported,
};

final misskeyVisibilityRosetta = Rosetta<String, PostScope>(const {
  'specified': PostScope.direct,
  'followers': PostScope.followersOnly,
  'home': PostScope.unlisted,
  'public': PostScope.public,
});

Uri buildEmojiUri(String localHost, EmojiHandle handle) {
  final (name, host) = handle;
  return Uri.https(localHost).replace(
    pathSegments: [
      'emoji',
      if (host == null || localHost == host)
        '$name.webp'
      else
        '$name@$host.webp',
    ],
  );
}

Emoji? getEmojiFromString(String key, List<CustomEmoji> mappedEmoji) {
  final emoji = mappedEmoji.firstWhereOrNull(
    (e) {
      if (key.length < 3) return false;
      final split = key.substring(1, key.length - 1).split('@');
      final name = split[0];
      final host = split.length == 2 ? split[1] : null;
      return e.short == name && (host == null || e.instance == host);
    },
  );

  return emoji;
}

bool isCustomEmoji(String input) =>
    input.length >= 3 && input.startsWith(':') && input.endsWith(':');

PostList toList(MisskeyList list) {
  return PostList(
    id: list.id,
    name: list.name,
    createdAt: list.createdAt,
    source: list.createdAt,
  );
}

DateTime? _parseBirthday(String? birthday) {
  if (birthday == null) {
    return null;
  }

  final dateFormat = DateFormat('yyyy-MM-dd');
  return dateFormat.parseStrict(birthday);
}

EmojiHandle _splitEmoji(String key) {
  if (key.startsWith(':') && key.endsWith(':')) {
    key = key.substring(1, key.length - 1);
  }

  final split = key.split('@');
  final hasHost = split.length >= 2 && split[1] != '.';
  return (split[0], hasHost ? split[1] : null);
}

typedef EmojiHandle = (String name, String? host);

extension KaitekiMisskeyDriveFileExtension on misskey.DriveFile {
  Attachment toKaiteki() {
    final mainType = this.type.split('/').first.toLowerCase();

    final type = switch (mainType) {
      'video' => AttachmentType.video,
      'image' => AttachmentType.image,
      'audio' => AttachmentType.audio,
      _ => AttachmentType.file
    };

    return Attachment(
      source: this,
      fileName: name,
      previewUrl: Uri.parse(thumbnailUrl ?? url!),
      url: Uri.parse(url!),
      type: type,
      isSensitive: isSensitive,
      blurHash: blurhash,
    );
  }
}

extension KaitekiMisskeyEmojiExtension on misskey.Emoji {
  CustomEmoji toKaiteki(String localHost) {
    final handle = _splitEmoji(name);
    return CustomEmoji(
      short: handle.$1,
      url: Uri.parse(url),
      aliases: aliases,
      instance: handle.$2 ?? localHost,
    );
  }
}

extension KaitekiMisskeyMessagingMessageExtension on misskey.MessagingMessage {
  ChatMessage toKaiteki(String localHost) {
    final file = this.file;
    return ChatMessage(
      author: user!.toKaiteki(localHost),
      content: text,
      sentAt: createdAt,
      emojis: [],
      attachments: [if (file != null) file.toKaiteki()],
    );
  }
}

extension KaitekiMisskeyMetaExtension on misskey.Meta {
  Instance toKaiteki(Uri instanceUri) {
    return Instance(
      source: this,
      name: name,
      description: description,
      iconUrl: iconUrl.nullTransform(instanceUri.resolve),
      mascotUrl: mascotImageUrl.nullTransform(instanceUri.resolve),
      backgroundUrl: bannerUrl.nullTransform(Uri.parse),
    );
  }
}

extension KaitekiMisskeyNoteExtension on misskey.Note {
  // Since Misskey does not provide any URL to local notes, we have to figure
  // out the URL on our own now.
  Uri getUrl(String localHost) {
    final url = this.url;
    if (url != null) return url;

    final uri = this.uri;
    if (uri != null) return uri;

    return Uri(
      scheme: 'https',
      host: localHost,
      pathSegments: ['notes', id],
    );
  }

  Post toKaiteki(String localHost) {
    final mappedEmoji =
        emojis?.map<CustomEmoji>((e) => e.toKaiteki(localHost)).toList();
    final sourceReply = reply;
    final sourceReplyId = replyId;

    ResolvablePost? replyTo;
    if (sourceReplyId != null) {
      replyTo = sourceReply == null
          ? ResolvablePost.fromId(sourceReplyId)
          : sourceReply.toKaiteki(localHost).resolved;
    }

    Reaction convertReaction(MapEntry<String, int> reaction) {
      Emoji? emoji;

      if (mappedEmoji != null) {
        emoji = getEmojiFromString(reaction.key, mappedEmoji);
      } else if (isCustomEmoji(reaction.key)) {
        final emojiKey = _splitEmoji(reaction.key);
        final emojiUrl = buildEmojiUri(localHost, emojiKey);
        emoji = CustomEmoji(
          short: emojiKey.$1,
          url: emojiUrl,
          instance: emojiKey.$2 ?? localHost,
        );
      }

      return Reaction(
        count: reaction.value,
        includesMe: reaction.key == myReaction,
        emoji: emoji ?? UnicodeEmoji(reaction.key),
      );
    }

    final renote = this.renote.nullTransform((n) => n.toKaiteki(localHost));
    final isQuote = text != null || fileIds?.isNotEmpty == true || poll != null;

    return Post(
      source: this,
      postedAt: createdAt,
      author: user.toKaiteki(localHost),
      subject: cw,
      content: text,
      emojis: mappedEmoji,
      reactions: reactions.entries.map(convertReaction).toList(),
      replyTo: replyTo,
      repeatOf: isQuote ? null : renote,
      quotedPost: isQuote ? renote : null,
      id: id,
      visibility: misskeyVisibilityRosetta.getRight(visibility),
      attachments: files?.map((f) => f.toKaiteki()).toList(),
      externalUrl: getUrl(localHost),
      metrics: PostMetrics(
        repeatCount: renoteCount,
        replyCount: repliesCount,
      ),
      poll: poll?.toKaiteki(),
    );
  }
}

extension KaitekiMisskeyPollExtension on misskey.Poll {
  Poll toKaiteki() {
    final expiresAt = this.expiresAt;
    return Poll(
      source: this,
      options: choices.map((e) => PollOption(e.text, e.votes)).toList(),
      endsAt: expiresAt,
      voteCount: choices.map((e) => e.votes).sum,
      allowMultipleChoices: multiple,
      hasEnded: expiresAt == null ? false : DateTime.now().isBefore(expiresAt),
    );
  }
}

extension KaitekiMisskeyNotificationExtension on misskey.Notification {
  Notification toKaiteki(String localHost) {
    return Notification(
      id: id,
      createdAt: createdAt,
      type: misskeyNotificationTypeRosetta[type]!,
      user: user?.toKaiteki(localHost),
      post: note?.toKaiteki(localHost),
      unread: !(isRead ?? true),
    );
  }
}

extension KaitekiMisskeyUserExtension on misskey.User {
  User toKaiteki(String localHost) {
    UserFollowState getFollowState() {
      if (isFollowing == true) return UserFollowState.following;

      if (hasPendingFollowRequestFromYou == true ||
          hasPendingReceivedFollowRequest == true) {
        return UserFollowState.pending;
      }

      return UserFollowState.notFollowing;
    }

    return User(
      avatarUrl: avatarUrl,
      avatarBlurHash: avatarBlurhash,
      bannerUrl: bannerUrl,
      bannerBlurHash: bannerBlurhash,
      description: description,
      displayName: name,
      emojis: emojis?.map((e) => e.toKaiteki(localHost)).toList(),
      host: host ?? localHost,
      id: id,
      joinDate: createdAt,
      source: this,
      username: username,
      details: UserDetails(
        location: location,
        birthday: _parseBirthday(birthday),
        fields: fields?.map((e) => MapEntry(e.name, e.value)).toList(),
      ),
      state: UserState(
        isBlocked: isBlocked,
        isMuted: isMuted,
        follow: getFollowState(),
      ),
      metrics: UserMetrics(
        followerCount: followersCount,
        followingCount: followingCount,
        postCount: notesCount,
      ),
      flags: UserFlags(
        isAdministrator: isAdmin,
        isModerator: isModerator,
        isApprovingFollowers: isLocked,
      ),
      type: isBot == true ? UserType.bot : UserType.person,
      avatarDecorations: [
        if (isCat == true) AnimalEarAvatarDecoration.cat(),
        ...?avatarDecorations?.map(
          (e) => OverlayAvatarDecoration(
            url: e.url,
            id: e.id,
            flipHorizontally: e.flipH ?? false,
            angle: e.angle ?? 0,
          ),
        ),
      ],
    );
  }
}

extension KaitekiMisskeyAnnouncementExtension on misskey.Announcement {
  Announcement toKaiteki() {
    return Announcement(
      id: id,
      important: showPopup == true || needsConfirmationToRead == true,
      createdAt: createdAt,
      updatedAt: updatedAt,
      title: title,
      content: text,
      isUnread: isRead == false,
    );
  }
}
