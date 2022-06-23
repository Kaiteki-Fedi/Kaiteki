import 'package:kaiteki/fediverse/model/attachment.dart';
import 'package:kaiteki/fediverse/model/emoji.dart';
import 'package:kaiteki/fediverse/model/formatting.dart';
import 'package:kaiteki/fediverse/model/preview_card.dart';
import 'package:kaiteki/fediverse/model/reaction.dart';
import 'package:kaiteki/fediverse/model/user.dart';
import 'package:kaiteki/fediverse/model/user_reference.dart';
import 'package:kaiteki/fediverse/model/visibility.dart';

/// A class representing a post.
class Post<T> {
  /// The original object.
  final T? source;
  final String id;

  // METADATA
  final DateTime postedAt;
  final User author;
  final bool nsfw;
  final Visibility? visibility;

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

  /// What reactions this post has
  final Iterable<Reaction> reactions;

  // CONTENT
  final String? subject;
  final String? content;
  final Formatting? formatting;
  final Iterable<Attachment>? attachments;
  final Iterable<Emoji>? emojis;

  // REPLYING
  final String? replyToPostId;
  final String? replyToUserId;
  final Post? replyTo;
  final User? replyToUser;

  final Post? repeatOf;
  final Post? quotedPost;
  final PreviewCard? previewCard;

  final List<UserReference>? mentionedUsers;

  final String? externalUrl;

  Post({
    required this.source,
    required this.postedAt,
    required this.author,
    required this.id,
    Iterable<Reaction>? reactions,
    required this.visibility,
    this.content,
    this.subject,
    this.nsfw = false,
    this.formatting = Formatting.plainText,
    this.liked = false,
    this.repeated = false,
    this.attachments,
    this.emojis,
    this.repeatOf,
    this.replyTo,
    this.previewCard,
    this.likeCount = 0,
    this.repeatCount = 0,
    this.replyCount = 0,
    this.replyToUserId,
    this.replyToPostId,
    this.externalUrl,
    this.replyToUser,
    this.quotedPost,
    List<UserReference>? mentionedUsers,
  })  : reactions = reactions ?? [],
        mentionedUsers = mentionedUsers ?? [];

  factory Post.example() {
    return Post(
      author: User.example(),
      content: "Hello everyone!",
      source: null,
      postedAt: DateTime.now(),
      reactions: [],
      id: 'cool-post',
      visibility: Visibility.public,
    );
  }
}
