// ignore_for_file: avoid_returning_this

import 'package:collection/collection.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:kaiteki/fediverse/model/adapted_entity.dart';
import 'package:kaiteki/fediverse/model/model.dart';

export 'draft.dart';
export 'metrics.dart';
export 'state.dart';

part 'post.g.dart';

/// A class representing a post.
@CopyWith()
class Post<T> extends AdaptedEntity<T> {
  /// The original object.
  final String id;

  // METADATA
  final DateTime postedAt;
  final User author;
  final bool nsfw;
  final Visibility? visibility;

  final PostMetrics metrics;
  final PostState state;

  /// What reactions this post has
  final List<Reaction> reactions;

  // CONTENT
  final String? subject;
  final String? content;
  final Formatting? formatting;
  final List<Attachment>? attachments;
  final List<Emoji>? emojis;

  final List<Embed> embeds;

  /// The client used to make this post.
  final String? client;

  final Poll? poll;

  final ResolvablePost? replyTo;
  final ResolvableUser? replyToUser;

  final Post? repeatOf;
  final Post? quotedPost;

  final List<UserReference>? mentionedUsers;

  final Uri? externalUrl;

  Post({
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
  });

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

    return copyWith.reactions(reactions);
  }

  Post removeOrDeleteReaction(Emoji emoji, User? user) {
    final reactions = this.reactions;

    final i = reactions.indexWhere((r) => r.emoji == emoji);

    if (i == -1) {
      throw Exception("Emoji not found");
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

    return copyWith.reactions(reactions);
  }
}

enum PostFlag {
  repeatable,
  replyable,
  favoritable,
  federatable,
}
