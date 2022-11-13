import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:kaiteki/fediverse/model/attachment.dart';
import 'package:kaiteki/fediverse/model/embed.dart';
import 'package:kaiteki/fediverse/model/emoji.dart';
import 'package:kaiteki/fediverse/model/formatting.dart';
import 'package:kaiteki/fediverse/model/reaction.dart';
import 'package:kaiteki/fediverse/model/user.dart';
import 'package:kaiteki/fediverse/model/user_reference.dart';
import 'package:kaiteki/fediverse/model/visibility.dart';

part 'post.g.dart';

/// A class representing a post.
@CopyWith()
class Post<T> {
  /// The original object.
  final T? source;
  final String id;

  // METADATA
  final DateTime postedAt;
  final User author;
  final bool nsfw;
  final Visibility? visibility;
  final bool pinned;

  // ENGAGEMENT
  /// Whether the user has liked (favorited) this post
  final bool liked;

  /// Whether the user has repeated (boosted, retweeted, etc.) this post
  final bool repeated;

  /// How many users have liked this post
  final int likeCount;

  /// How many users have repeated (boosted, retweeted, etc.) this post
  final int repeatCount;

  /// How many users have replied to this post
  final int replyCount;

  final bool bookmarked;

  /// What reactions this post has
  final Iterable<Reaction> reactions;

  // CONTENT
  final String? subject;
  final String? content;
  final Formatting? formatting;
  final Iterable<Attachment>? attachments;
  final Iterable<Emoji>? emojis;

  final List<Embed> embeds;

  /// The client used to make this post.
  final String? client;

  // REPLYING
  final String? replyToPostId;
  final String? replyToUserId;
  final Post? replyTo;
  final User? replyToUser;

  final Post? repeatOf;
  final Post? quotedPost;

  final List<UserReference>? mentionedUsers;

  final String? externalUrl;

  Post({
    required this.source,
    required this.postedAt,
    required this.author,
    required this.id,
    this.reactions = const [],
    this.mentionedUsers = const [],
    this.attachments,
    this.bookmarked = false,
    this.content,
    this.embeds = const [],
    this.emojis,
    this.externalUrl,
    this.formatting = Formatting.plainText,
    this.likeCount = 0,
    this.liked = false,
    this.nsfw = false,
    this.pinned = false,
    this.quotedPost,
    this.repeatCount = 0,
    this.repeated = false,
    this.repeatOf,
    this.replyCount = 0,
    this.replyTo,
    this.replyToPostId,
    this.replyToUser,
    this.replyToUserId,
    this.subject,
    this.visibility,
    this.client,
  });
}
