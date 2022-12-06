// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PostCWProxy<T> {
  Post<T> attachments(List<Attachment<dynamic>>? attachments);

  Post<T> author(User<dynamic> author);

  Post<T> client(String? client);

  Post<T> content(String? content);

  Post<T> embeds(List<Embed> embeds);

  Post<T> emojis(List<Emoji>? emojis);

  Post<T> externalUrl(Uri? externalUrl);

  Post<T> formatting(Formatting? formatting);

  Post<T> id(String id);

  Post<T> mentionedUsers(List<UserReference>? mentionedUsers);

  Post<T> metrics(PostMetrics metrics);

  Post<T> nsfw(bool nsfw);

  Post<T> postedAt(DateTime postedAt);

  Post<T> quotedPost(Post<dynamic>? quotedPost);

  Post<T> reactions(List<Reaction> reactions);

  Post<T> repeatOf(Post<dynamic>? repeatOf);

  Post<T> replyTo(Post<dynamic>? replyTo);

  Post<T> replyToPostId(String? replyToPostId);

  Post<T> replyToUser(User<dynamic>? replyToUser);

  Post<T> replyToUserId(String? replyToUserId);

  Post<T> source(T? source);

  Post<T> state(PostState state);

  Post<T> subject(String? subject);

  Post<T> visibility(Visibility? visibility);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Post<T>(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Post<T>(...).copyWith(id: 12, name: "My name")
  /// ````
  Post<T> call({
    List<Attachment<dynamic>>? attachments,
    User<dynamic>? author,
    String? client,
    String? content,
    List<Embed>? embeds,
    List<Emoji>? emojis,
    Uri? externalUrl,
    Formatting? formatting,
    String? id,
    List<UserReference>? mentionedUsers,
    PostMetrics? metrics,
    bool? nsfw,
    DateTime? postedAt,
    Post<dynamic>? quotedPost,
    List<Reaction>? reactions,
    Post<dynamic>? repeatOf,
    Post<dynamic>? replyTo,
    String? replyToPostId,
    User<dynamic>? replyToUser,
    String? replyToUserId,
    T? source,
    PostState? state,
    String? subject,
    Visibility? visibility,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPost.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPost.copyWith.fieldName(...)`
class _$PostCWProxyImpl<T> implements _$PostCWProxy<T> {
  final Post<T> _value;

  const _$PostCWProxyImpl(this._value);

  @override
  Post<T> attachments(List<Attachment<dynamic>>? attachments) =>
      this(attachments: attachments);

  @override
  Post<T> author(User<dynamic> author) => this(author: author);

  @override
  Post<T> client(String? client) => this(client: client);

  @override
  Post<T> content(String? content) => this(content: content);

  @override
  Post<T> embeds(List<Embed> embeds) => this(embeds: embeds);

  @override
  Post<T> emojis(List<Emoji>? emojis) => this(emojis: emojis);

  @override
  Post<T> externalUrl(Uri? externalUrl) => this(externalUrl: externalUrl);

  @override
  Post<T> formatting(Formatting? formatting) => this(formatting: formatting);

  @override
  Post<T> id(String id) => this(id: id);

  @override
  Post<T> mentionedUsers(List<UserReference>? mentionedUsers) =>
      this(mentionedUsers: mentionedUsers);

  @override
  Post<T> metrics(PostMetrics metrics) => this(metrics: metrics);

  @override
  Post<T> nsfw(bool nsfw) => this(nsfw: nsfw);

  @override
  Post<T> postedAt(DateTime postedAt) => this(postedAt: postedAt);

  @override
  Post<T> quotedPost(Post<dynamic>? quotedPost) => this(quotedPost: quotedPost);

  @override
  Post<T> reactions(List<Reaction> reactions) => this(reactions: reactions);

  @override
  Post<T> repeatOf(Post<dynamic>? repeatOf) => this(repeatOf: repeatOf);

  @override
  Post<T> replyTo(Post<dynamic>? replyTo) => this(replyTo: replyTo);

  @override
  Post<T> replyToPostId(String? replyToPostId) =>
      this(replyToPostId: replyToPostId);

  @override
  Post<T> replyToUser(User<dynamic>? replyToUser) =>
      this(replyToUser: replyToUser);

  @override
  Post<T> replyToUserId(String? replyToUserId) =>
      this(replyToUserId: replyToUserId);

  @override
  Post<T> source(T? source) => this(source: source);

  @override
  Post<T> state(PostState state) => this(state: state);

  @override
  Post<T> subject(String? subject) => this(subject: subject);

  @override
  Post<T> visibility(Visibility? visibility) => this(visibility: visibility);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Post<T>(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Post<T>(...).copyWith(id: 12, name: "My name")
  /// ````
  Post<T> call({
    Object? attachments = const $CopyWithPlaceholder(),
    Object? author = const $CopyWithPlaceholder(),
    Object? client = const $CopyWithPlaceholder(),
    Object? content = const $CopyWithPlaceholder(),
    Object? embeds = const $CopyWithPlaceholder(),
    Object? emojis = const $CopyWithPlaceholder(),
    Object? externalUrl = const $CopyWithPlaceholder(),
    Object? formatting = const $CopyWithPlaceholder(),
    Object? id = const $CopyWithPlaceholder(),
    Object? mentionedUsers = const $CopyWithPlaceholder(),
    Object? metrics = const $CopyWithPlaceholder(),
    Object? nsfw = const $CopyWithPlaceholder(),
    Object? postedAt = const $CopyWithPlaceholder(),
    Object? quotedPost = const $CopyWithPlaceholder(),
    Object? reactions = const $CopyWithPlaceholder(),
    Object? repeatOf = const $CopyWithPlaceholder(),
    Object? replyTo = const $CopyWithPlaceholder(),
    Object? replyToPostId = const $CopyWithPlaceholder(),
    Object? replyToUser = const $CopyWithPlaceholder(),
    Object? replyToUserId = const $CopyWithPlaceholder(),
    Object? source = const $CopyWithPlaceholder(),
    Object? state = const $CopyWithPlaceholder(),
    Object? subject = const $CopyWithPlaceholder(),
    Object? visibility = const $CopyWithPlaceholder(),
  }) {
    return Post<T>(
      attachments: attachments == const $CopyWithPlaceholder()
          ? _value.attachments
          // ignore: cast_nullable_to_non_nullable
          : attachments as List<Attachment<dynamic>>?,
      author: author == const $CopyWithPlaceholder() || author == null
          ? _value.author
          // ignore: cast_nullable_to_non_nullable
          : author as User<dynamic>,
      client: client == const $CopyWithPlaceholder()
          ? _value.client
          // ignore: cast_nullable_to_non_nullable
          : client as String?,
      content: content == const $CopyWithPlaceholder()
          ? _value.content
          // ignore: cast_nullable_to_non_nullable
          : content as String?,
      embeds: embeds == const $CopyWithPlaceholder() || embeds == null
          ? _value.embeds
          // ignore: cast_nullable_to_non_nullable
          : embeds as List<Embed>,
      emojis: emojis == const $CopyWithPlaceholder()
          ? _value.emojis
          // ignore: cast_nullable_to_non_nullable
          : emojis as List<Emoji>?,
      externalUrl: externalUrl == const $CopyWithPlaceholder()
          ? _value.externalUrl
          // ignore: cast_nullable_to_non_nullable
          : externalUrl as Uri?,
      formatting: formatting == const $CopyWithPlaceholder()
          ? _value.formatting
          // ignore: cast_nullable_to_non_nullable
          : formatting as Formatting?,
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      mentionedUsers: mentionedUsers == const $CopyWithPlaceholder()
          ? _value.mentionedUsers
          // ignore: cast_nullable_to_non_nullable
          : mentionedUsers as List<UserReference>?,
      metrics: metrics == const $CopyWithPlaceholder() || metrics == null
          ? _value.metrics
          // ignore: cast_nullable_to_non_nullable
          : metrics as PostMetrics,
      nsfw: nsfw == const $CopyWithPlaceholder() || nsfw == null
          ? _value.nsfw
          // ignore: cast_nullable_to_non_nullable
          : nsfw as bool,
      postedAt: postedAt == const $CopyWithPlaceholder() || postedAt == null
          ? _value.postedAt
          // ignore: cast_nullable_to_non_nullable
          : postedAt as DateTime,
      quotedPost: quotedPost == const $CopyWithPlaceholder()
          ? _value.quotedPost
          // ignore: cast_nullable_to_non_nullable
          : quotedPost as Post<dynamic>?,
      reactions: reactions == const $CopyWithPlaceholder() || reactions == null
          ? _value.reactions
          // ignore: cast_nullable_to_non_nullable
          : reactions as List<Reaction>,
      repeatOf: repeatOf == const $CopyWithPlaceholder()
          ? _value.repeatOf
          // ignore: cast_nullable_to_non_nullable
          : repeatOf as Post<dynamic>?,
      replyTo: replyTo == const $CopyWithPlaceholder()
          ? _value.replyTo
          // ignore: cast_nullable_to_non_nullable
          : replyTo as Post<dynamic>?,
      replyToPostId: replyToPostId == const $CopyWithPlaceholder()
          ? _value.replyToPostId
          // ignore: cast_nullable_to_non_nullable
          : replyToPostId as String?,
      replyToUser: replyToUser == const $CopyWithPlaceholder()
          ? _value.replyToUser
          // ignore: cast_nullable_to_non_nullable
          : replyToUser as User<dynamic>?,
      replyToUserId: replyToUserId == const $CopyWithPlaceholder()
          ? _value.replyToUserId
          // ignore: cast_nullable_to_non_nullable
          : replyToUserId as String?,
      source: source == const $CopyWithPlaceholder()
          ? _value.source
          // ignore: cast_nullable_to_non_nullable
          : source as T?,
      state: state == const $CopyWithPlaceholder() || state == null
          ? _value.state
          // ignore: cast_nullable_to_non_nullable
          : state as PostState,
      subject: subject == const $CopyWithPlaceholder()
          ? _value.subject
          // ignore: cast_nullable_to_non_nullable
          : subject as String?,
      visibility: visibility == const $CopyWithPlaceholder()
          ? _value.visibility
          // ignore: cast_nullable_to_non_nullable
          : visibility as Visibility?,
    );
  }
}

extension $PostCopyWith<T> on Post<T> {
  /// Returns a callable class that can be used as follows: `instanceOfPost.copyWith(...)` or like so:`instanceOfPost.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PostCWProxy<T> get copyWith => _$PostCWProxyImpl<T>(this);
}
