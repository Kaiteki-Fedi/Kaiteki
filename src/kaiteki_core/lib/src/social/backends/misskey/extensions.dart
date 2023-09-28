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
  misskey.NotificationType.receiveFollowRequest: NotificationType.followRequest,
  misskey.NotificationType.followRequestAccepted: NotificationType.followed,
  misskey.NotificationType.groupInvited: NotificationType.groupInvite,
  misskey.NotificationType.achievementEarned: NotificationType.unsupported,
};

final misskeyVisibilityRosetta = Rosetta<String, Visibility>(const {
  'specified': Visibility.direct,
  'followers': Visibility.followersOnly,
  'home': Visibility.unlisted,
  'public': Visibility.public,
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

Map<String, String>? _parseFields(Iterable<JsonMap>? fields) {
  if (fields == null) return null;

  return Map<String, String>.fromEntries(
    fields.map(
      (e) => MapEntry(
        e['name'] as String,
        e['value'] as String,
      ),
    ),
  );
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

    return Post(
      source: this,
      postedAt: createdAt,
      author: user.toKaiteki(localHost),
      subject: cw,
      content: text,
      emojis: mappedEmoji,
      reactions: reactions.entries.map(convertReaction).toList(),
      replyTo: replyTo,
      repeatOf: renote.nullTransform((n) => n.toKaiteki(localHost)),
      id: id,
      visibility: misskeyVisibilityRosetta.getRight(visibility),
      attachments: files?.map((f) => f.toKaiteki()).toList(),
      // FIXME(Craftplacer): Change to Uri?
      externalUrl: url.nullTransform(Uri.parse),
      metrics: PostMetrics(
        repeatCount: renoteCount,
        replyCount: repliesCount,
      ),
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

extension KaitekiMisskeyUserExtension on misskey.UserLite {
  User toKaiteki(String localHost) {
    final detailed = safeCast<misskey.User>();

    UserFollowState getFollowState() {
      if (detailed?.isFollowing == true) return UserFollowState.following;

      if (detailed?.hasPendingFollowRequestFromYou == true ||
          detailed?.hasPendingReceivedFollowRequest == true) {
        return UserFollowState.pending;
      }

      return UserFollowState.notFollowing;
    }

    return User(
      avatarUrl: avatarUrl.nullTransform(Uri.parse),
      avatarBlurHash: detailed?.avatarBlurhash,
      bannerUrl: detailed?.bannerUrl.nullTransform(Uri.parse),
      bannerBlurHash: detailed?.bannerBlurhash as String?,
      description: detailed?.description,
      displayName: name,
      emojis: emojis?.map((e) => e.toKaiteki(localHost)).toList(),
      host: host ?? localHost,
      id: id,
      joinDate: detailed?.createdAt,
      source: this,
      username: username,
      details: UserDetails(
        location: detailed?.location,
        birthday: _parseBirthday(detailed?.birthday),
        fields: _parseFields(detailed?.fields),
      ),
      state: UserState(
        isBlocked: detailed?.isBlocked,
        isMuted: detailed?.isMuted,
        follow: getFollowState(),
      ),
      metrics: UserMetrics(
        followerCount: detailed?.followersCount,
        followingCount: detailed?.followingCount,
        postCount: detailed?.notesCount,
      ),
      flags: UserFlags(
        isAdministrator: isAdmin,
        isModerator: isModerator,
        isApprovingFollowers: detailed?.isLocked,
      ),
      type: isBot == true ? UserType.bot : UserType.person,
    );
  }
}
