// ignore_for_file: avoid_returning_this

import 'package:collection/collection.dart';

import 'adapted_entity.dart';
import 'attachment.dart';
import 'embed.dart';
import 'emoji.dart';
import 'formatting.dart';
import 'poll.dart';
import 'reaction.dart';
import 'resolvable.dart';
import 'user.dart';
import 'user_reference.dart';
import 'visibility.dart';
import 'post.dart';

export 'draft.dart';
export 'post_metrics.dart';
export 'post_state.dart';

/// A class representing a post.
class Post<T> extends AdaptedEntity<T> {
  final String id;
  final DateTime postedAt;
  final User author;
  final bool nsfw;
  final Visibility? visibility;
  final PostMetrics metrics;
  final PostState state;
  final List<Reaction> reactions;
  final String? subject;
  final String? content;
  final Formatting? formatting;
  final List<Attachment>? attachments;
  final List<Emoji>? emojis;
  final List<Embed> embeds;
  final String? client;
  final Poll? poll;
  final ResolvablePost? replyTo;
  final ResolvableUser? replyToUser;
  final Post? repeatOf;
  final Post? quotedPost;
  final List<UserReference>? mentionedUsers;
  final Uri? externalUrl;
  final String? language;

  const Post({
    super.source,
    required this.postedAt,
    required this.author,
    required this.id,
    this.reactions = const [],
    this.mentionedUsers = const [],
    this.attachments,
    this.content,
    this.embeds = const [],
    this.emojis,
    this.externalUrl,
    this.formatting = Formatting.plainText,
    this.metrics = const PostMetrics(),
    this.state = const PostState(),
    this.nsfw = false,
    this.quotedPost,
    this.repeatOf,
    this.replyTo,
    this.replyToUser,
    this.subject,
    this.visibility,
    this.client,
    this.poll,
    this.language,
  });

  Post<T> copyWith({
    String? id,
    DateTime? postedAt,
    User? author,
    bool? nsfw,
    Visibility? visibility,
    PostMetrics? metrics,
    PostState? state,
    List<Reaction>? reactions,
    String? subject,
    String? content,
    Formatting? formatting,
    List<Attachment>? attachments,
    List<Emoji>? emojis,
    List<Embed>? embeds,
    String? client,
    Poll? poll,
    ResolvablePost? replyTo,
    ResolvableUser? replyToUser,
    Post? repeatOf,
    Post? quotedPost,
    List<UserReference>? mentionedUsers,
    Uri? externalUrl,
    String? language,
  }) {
    return Post(
      id: id ?? this.id,
      postedAt: postedAt ?? this.postedAt,
      author: author ?? this.author,
      nsfw: nsfw ?? this.nsfw,
      visibility: visibility ?? this.visibility,
      metrics: metrics ?? this.metrics,
      state: state ?? this.state,
      reactions: reactions ?? this.reactions,
      subject: subject ?? this.subject,
      content: content ?? this.content,
      formatting: formatting ?? this.formatting,
      attachments: attachments ?? this.attachments,
      emojis: emojis ?? this.emojis,
      embeds: embeds ?? this.embeds,
      client: client ?? this.client,
      poll: poll ?? this.poll,
      replyTo: replyTo ?? this.replyTo,
      replyToUser: replyToUser ?? this.replyToUser,
      repeatOf: repeatOf ?? this.repeatOf,
      quotedPost: quotedPost ?? this.quotedPost,
      mentionedUsers: mentionedUsers ?? this.mentionedUsers,
      externalUrl: externalUrl ?? this.externalUrl,
      language: language ?? this.language,
    );
  }

  Post addOrCreateReaction(
    Emoji emoji,
    User? user, [
    bool replaceExisting = false,
  ]) {
    final List<Reaction> reactions;

    if (replaceExisting && this.reactions.any((r) => r.includesMe)) {
      reactions = removeOrDeleteReaction(emoji, user).reactions;
    } else {
      reactions = this.reactions;
    }

    final i = reactions.indexWhere((r) => r.emoji == emoji);

    if (i == -1) {
      reactions.add(Reaction(emoji: emoji, includesMe: true, count: 1));
    } else {
      final reaction = reactions[i];

      if (reaction.includesMe) return this; // noop

      reactions[i] = reaction.copyWith(
        includesMe: true,
        count: reaction.count + 1,
        users: reaction.users == null ? null : [...reaction.users!, user!],
      );
    }

    return copyWith(reactions: reactions);
  }

  Post removeOrDeleteReaction(Emoji emoji, User? user) {
    final reactions = this.reactions;

    final i = reactions.indexWhere((r) => r.emoji == emoji);

    if (i == -1) {
      throw Exception('Emoji not found');
    } else {
      final reaction = reactions[i];

      if (!reaction.includesMe) return this; // noop

      if (reaction.count == 1) {
        reactions.removeAt(i);
      } else {
        reactions[i] = reaction.copyWith(
          includesMe: false,
          count: reaction.count - 1,
          users: reaction.users?.whereNot((u) => u == user).toList(),
        );
      }
    }

    return copyWith(reactions: reactions);
  }
}
