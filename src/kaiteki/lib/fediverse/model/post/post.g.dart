// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PostCWProxy<T> {
  Post<T> source(T? source);

  Post<T> postedAt(DateTime postedAt);

  Post<T> author(User<dynamic> author);

  Post<T> id(String id);

  Post<T> reactions(List<Reaction> reactions);

  Post<T> mentionedUsers(List<UserReference>? mentionedUsers);

  Post<T> attachments(List<Attachment<dynamic>>? attachments);

  Post<T> content(String? content);

  Post<T> embeds(List<Embed> embeds);

  Post<T> emojis(List<Emoji>? emojis);

  Post<T> externalUrl(Uri? externalUrl);

  Post<T> formatting(Formatting? formatting);

  Post<T> metrics(PostMetrics metrics);

  Post<T> state(PostState state);

  Post<T> nsfw(bool nsfw);

  Post<T> quotedPost(Post<dynamic>? quotedPost);

  Post<T> repeatOf(Post<dynamic>? repeatOf);

  Post<T> replyTo(ResolvablePost? replyTo);

  Post<T> replyToUser(ResolvableUser? replyToUser);

  Post<T> subject(String? subject);

  Post<T> visibility(Visibility? visibility);

  Post<T> client(String? client);

  Post<T> poll(Poll<dynamic>? poll);

  Post<T> language(String? language);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Post<T>(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Post<T>(...).copyWith(id: 12, name: "My name")
  /// ````
  Post<T> call({
    T? source,
    DateTime? postedAt,
    User<dynamic>? author,
    String? id,
    List<Reaction>? reactions,
    List<UserReference>? mentionedUsers,
    List<Attachment<dynamic>>? attachments,
    String? content,
    List<Embed>? embeds,
    List<Emoji>? emojis,
    Uri? externalUrl,
    Formatting? formatting,
    PostMetrics? metrics,
    PostState? state,
    bool? nsfw,
    Post<dynamic>? quotedPost,
    Post<dynamic>? repeatOf,
    ResolvablePost? replyTo,
    ResolvableUser? replyToUser,
    String? subject,
    Visibility? visibility,
    String? client,
    Poll<dynamic>? poll,
    String? language,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPost.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPost.copyWith.fieldName(...)`
class _$PostCWProxyImpl<T> implements _$PostCWProxy<T> {
  const _$PostCWProxyImpl(this._value);

  final Post<T> _value;

  @override
  Post<T> source(T? source) => this(source: source);

  @override
  Post<T> postedAt(DateTime postedAt) => this(postedAt: postedAt);

  @override
  Post<T> author(User<dynamic> author) => this(author: author);

  @override
  Post<T> id(String id) => this(id: id);

  @override
  Post<T> reactions(List<Reaction> reactions) => this(reactions: reactions);

  @override
  Post<T> mentionedUsers(List<UserReference>? mentionedUsers) =>
      this(mentionedUsers: mentionedUsers);

  @override
  Post<T> attachments(List<Attachment<dynamic>>? attachments) =>
      this(attachments: attachments);

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
  Post<T> metrics(PostMetrics metrics) => this(metrics: metrics);

  @override
  Post<T> state(PostState state) => this(state: state);

  @override
  Post<T> nsfw(bool nsfw) => this(nsfw: nsfw);

  @override
  Post<T> quotedPost(Post<dynamic>? quotedPost) => this(quotedPost: quotedPost);

  @override
  Post<T> repeatOf(Post<dynamic>? repeatOf) => this(repeatOf: repeatOf);

  @override
  Post<T> replyTo(ResolvablePost? replyTo) => this(replyTo: replyTo);

  @override
  Post<T> replyToUser(ResolvableUser? replyToUser) =>
      this(replyToUser: replyToUser);

  @override
  Post<T> subject(String? subject) => this(subject: subject);

  @override
  Post<T> visibility(Visibility? visibility) => this(visibility: visibility);

  @override
  Post<T> client(String? client) => this(client: client);

  @override
  Post<T> poll(Poll<dynamic>? poll) => this(poll: poll);

  @override
  Post<T> language(String? language) => this(language: language);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Post<T>(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Post<T>(...).copyWith(id: 12, name: "My name")
  /// ````
  Post<T> call({
    Object? source = const $CopyWithPlaceholder(),
    Object? postedAt = const $CopyWithPlaceholder(),
    Object? author = const $CopyWithPlaceholder(),
    Object? id = const $CopyWithPlaceholder(),
    Object? reactions = const $CopyWithPlaceholder(),
    Object? mentionedUsers = const $CopyWithPlaceholder(),
    Object? attachments = const $CopyWithPlaceholder(),
    Object? content = const $CopyWithPlaceholder(),
    Object? embeds = const $CopyWithPlaceholder(),
    Object? emojis = const $CopyWithPlaceholder(),
    Object? externalUrl = const $CopyWithPlaceholder(),
    Object? formatting = const $CopyWithPlaceholder(),
    Object? metrics = const $CopyWithPlaceholder(),
    Object? state = const $CopyWithPlaceholder(),
    Object? nsfw = const $CopyWithPlaceholder(),
    Object? quotedPost = const $CopyWithPlaceholder(),
    Object? repeatOf = const $CopyWithPlaceholder(),
    Object? replyTo = const $CopyWithPlaceholder(),
    Object? replyToUser = const $CopyWithPlaceholder(),
    Object? subject = const $CopyWithPlaceholder(),
    Object? visibility = const $CopyWithPlaceholder(),
    Object? client = const $CopyWithPlaceholder(),
    Object? poll = const $CopyWithPlaceholder(),
    Object? language = const $CopyWithPlaceholder(),
  }) {
    return Post<T>(
      source: source == const $CopyWithPlaceholder()
          ? _value.source
          // ignore: cast_nullable_to_non_nullable
          : source as T?,
      postedAt: postedAt == const $CopyWithPlaceholder() || postedAt == null
          // ignore: unnecessary_non_null_assertion
          ? _value.postedAt!
          // ignore: cast_nullable_to_non_nullable
          : postedAt as DateTime,
      author: author == const $CopyWithPlaceholder() || author == null
          // ignore: unnecessary_non_null_assertion
          ? _value.author!
          // ignore: cast_nullable_to_non_nullable
          : author as User<dynamic>,
      id: id == const $CopyWithPlaceholder() || id == null
          // ignore: unnecessary_non_null_assertion
          ? _value.id!
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      reactions: reactions == const $CopyWithPlaceholder() || reactions == null
          // ignore: unnecessary_non_null_assertion
          ? _value.reactions!
          // ignore: cast_nullable_to_non_nullable
          : reactions as List<Reaction>,
      mentionedUsers: mentionedUsers == const $CopyWithPlaceholder()
          ? _value.mentionedUsers
          // ignore: cast_nullable_to_non_nullable
          : mentionedUsers as List<UserReference>?,
      attachments: attachments == const $CopyWithPlaceholder()
          ? _value.attachments
          // ignore: cast_nullable_to_non_nullable
          : attachments as List<Attachment<dynamic>>?,
      content: content == const $CopyWithPlaceholder()
          ? _value.content
          // ignore: cast_nullable_to_non_nullable
          : content as String?,
      embeds: embeds == const $CopyWithPlaceholder() || embeds == null
          // ignore: unnecessary_non_null_assertion
          ? _value.embeds!
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
      metrics: metrics == const $CopyWithPlaceholder() || metrics == null
          // ignore: unnecessary_non_null_assertion
          ? _value.metrics!
          // ignore: cast_nullable_to_non_nullable
          : metrics as PostMetrics,
      state: state == const $CopyWithPlaceholder() || state == null
          // ignore: unnecessary_non_null_assertion
          ? _value.state!
          // ignore: cast_nullable_to_non_nullable
          : state as PostState,
      nsfw: nsfw == const $CopyWithPlaceholder() || nsfw == null
          // ignore: unnecessary_non_null_assertion
          ? _value.nsfw!
          // ignore: cast_nullable_to_non_nullable
          : nsfw as bool,
      quotedPost: quotedPost == const $CopyWithPlaceholder()
          ? _value.quotedPost
          // ignore: cast_nullable_to_non_nullable
          : quotedPost as Post<dynamic>?,
      repeatOf: repeatOf == const $CopyWithPlaceholder()
          ? _value.repeatOf
          // ignore: cast_nullable_to_non_nullable
          : repeatOf as Post<dynamic>?,
      replyTo: replyTo == const $CopyWithPlaceholder()
          ? _value.replyTo
          // ignore: cast_nullable_to_non_nullable
          : replyTo as ResolvablePost?,
      replyToUser: replyToUser == const $CopyWithPlaceholder()
          ? _value.replyToUser
          // ignore: cast_nullable_to_non_nullable
          : replyToUser as ResolvableUser?,
      subject: subject == const $CopyWithPlaceholder()
          ? _value.subject
          // ignore: cast_nullable_to_non_nullable
          : subject as String?,
      visibility: visibility == const $CopyWithPlaceholder()
          ? _value.visibility
          // ignore: cast_nullable_to_non_nullable
          : visibility as Visibility?,
      client: client == const $CopyWithPlaceholder()
          ? _value.client
          // ignore: cast_nullable_to_non_nullable
          : client as String?,
      poll: poll == const $CopyWithPlaceholder()
          ? _value.poll
          // ignore: cast_nullable_to_non_nullable
          : poll as Poll<dynamic>?,
      language: language == const $CopyWithPlaceholder()
          ? _value.language
          // ignore: cast_nullable_to_non_nullable
          : language as String?,
    );
  }
}

extension $PostCopyWith<T> on Post<T> {
  /// Returns a callable class that can be used as follows: `instanceOfPost.copyWith(...)` or like so:`instanceOfPost.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PostCWProxy<T> get copyWith => _$PostCWProxyImpl<T>(this);
}
