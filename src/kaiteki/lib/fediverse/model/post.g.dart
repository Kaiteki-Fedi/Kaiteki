// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PostCWProxy<T> {
  Post<T> attachments(List<Attachment<dynamic>>? attachments);

  Post<T> author(User<dynamic> author);

  Post<T> bookmarked(bool bookmarked);

  Post<T> client(String? client);

  Post<T> content(String? content);

  Post<T> embeds(List<Embed> embeds);

  Post<T> emojis(List<Emoji<dynamic>>? emojis);

  Post<T> externalUrl(String? externalUrl);

  Post<T> formatting(Formatting? formatting);

  Post<T> id(String id);

  Post<T> likeCount(int likeCount);

  Post<T> liked(bool liked);

  Post<T> mentionedUsers(List<UserReference>? mentionedUsers);

  Post<T> nsfw(bool nsfw);

  Post<T> pinned(bool pinned);

  Post<T> postedAt(DateTime postedAt);

  Post<T> quotedPost(Post<dynamic>? quotedPost);

  Post<T> reactions(List<Reaction> reactions);

  Post<T> repeatCount(int repeatCount);

  Post<T> repeatOf(Post<dynamic>? repeatOf);

  Post<T> repeated(bool repeated);

  Post<T> replyCount(int replyCount);

  Post<T> replyTo(Post<dynamic>? replyTo);

  Post<T> replyToPostId(String? replyToPostId);

  Post<T> replyToUser(User<dynamic>? replyToUser);

  Post<T> replyToUserId(String? replyToUserId);

  Post<T> source(T? source);

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
    bool? bookmarked,
    String? client,
    String? content,
    List<Embed>? embeds,
    List<Emoji<dynamic>>? emojis,
    String? externalUrl,
    Formatting? formatting,
    String? id,
    int? likeCount,
    bool? liked,
    List<UserReference>? mentionedUsers,
    bool? nsfw,
    bool? pinned,
    DateTime? postedAt,
    Post<dynamic>? quotedPost,
    List<Reaction>? reactions,
    int? repeatCount,
    Post<dynamic>? repeatOf,
    bool? repeated,
    int? replyCount,
    Post<dynamic>? replyTo,
    String? replyToPostId,
    User<dynamic>? replyToUser,
    String? replyToUserId,
    T? source,
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
  Post<T> bookmarked(bool bookmarked) => this(bookmarked: bookmarked);

  @override
  Post<T> client(String? client) => this(client: client);

  @override
  Post<T> content(String? content) => this(content: content);

  @override
  Post<T> embeds(List<Embed> embeds) => this(embeds: embeds);

  @override
  Post<T> emojis(List<Emoji<dynamic>>? emojis) => this(emojis: emojis);

  @override
  Post<T> externalUrl(String? externalUrl) => this(externalUrl: externalUrl);

  @override
  Post<T> formatting(Formatting? formatting) => this(formatting: formatting);

  @override
  Post<T> id(String id) => this(id: id);

  @override
  Post<T> likeCount(int likeCount) => this(likeCount: likeCount);

  @override
  Post<T> liked(bool liked) => this(liked: liked);

  @override
  Post<T> mentionedUsers(List<UserReference>? mentionedUsers) =>
      this(mentionedUsers: mentionedUsers);

  @override
  Post<T> nsfw(bool nsfw) => this(nsfw: nsfw);

  @override
  Post<T> pinned(bool pinned) => this(pinned: pinned);

  @override
  Post<T> postedAt(DateTime postedAt) => this(postedAt: postedAt);

  @override
  Post<T> quotedPost(Post<dynamic>? quotedPost) => this(quotedPost: quotedPost);

  @override
  Post<T> reactions(List<Reaction> reactions) => this(reactions: reactions);

  @override
  Post<T> repeatCount(int repeatCount) => this(repeatCount: repeatCount);

  @override
  Post<T> repeatOf(Post<dynamic>? repeatOf) => this(repeatOf: repeatOf);

  @override
  Post<T> repeated(bool repeated) => this(repeated: repeated);

  @override
  Post<T> replyCount(int replyCount) => this(replyCount: replyCount);

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
    Object? bookmarked = const $CopyWithPlaceholder(),
    Object? client = const $CopyWithPlaceholder(),
    Object? content = const $CopyWithPlaceholder(),
    Object? embeds = const $CopyWithPlaceholder(),
    Object? emojis = const $CopyWithPlaceholder(),
    Object? externalUrl = const $CopyWithPlaceholder(),
    Object? formatting = const $CopyWithPlaceholder(),
    Object? id = const $CopyWithPlaceholder(),
    Object? likeCount = const $CopyWithPlaceholder(),
    Object? liked = const $CopyWithPlaceholder(),
    Object? mentionedUsers = const $CopyWithPlaceholder(),
    Object? nsfw = const $CopyWithPlaceholder(),
    Object? pinned = const $CopyWithPlaceholder(),
    Object? postedAt = const $CopyWithPlaceholder(),
    Object? quotedPost = const $CopyWithPlaceholder(),
    Object? reactions = const $CopyWithPlaceholder(),
    Object? repeatCount = const $CopyWithPlaceholder(),
    Object? repeatOf = const $CopyWithPlaceholder(),
    Object? repeated = const $CopyWithPlaceholder(),
    Object? replyCount = const $CopyWithPlaceholder(),
    Object? replyTo = const $CopyWithPlaceholder(),
    Object? replyToPostId = const $CopyWithPlaceholder(),
    Object? replyToUser = const $CopyWithPlaceholder(),
    Object? replyToUserId = const $CopyWithPlaceholder(),
    Object? source = const $CopyWithPlaceholder(),
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
      bookmarked:
          bookmarked == const $CopyWithPlaceholder() || bookmarked == null
              ? _value.bookmarked
              // ignore: cast_nullable_to_non_nullable
              : bookmarked as bool,
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
          : emojis as List<Emoji<dynamic>>?,
      externalUrl: externalUrl == const $CopyWithPlaceholder()
          ? _value.externalUrl
          // ignore: cast_nullable_to_non_nullable
          : externalUrl as String?,
      formatting: formatting == const $CopyWithPlaceholder()
          ? _value.formatting
          // ignore: cast_nullable_to_non_nullable
          : formatting as Formatting?,
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      likeCount: likeCount == const $CopyWithPlaceholder() || likeCount == null
          ? _value.likeCount
          // ignore: cast_nullable_to_non_nullable
          : likeCount as int,
      liked: liked == const $CopyWithPlaceholder() || liked == null
          ? _value.liked
          // ignore: cast_nullable_to_non_nullable
          : liked as bool,
      mentionedUsers: mentionedUsers == const $CopyWithPlaceholder()
          ? _value.mentionedUsers
          // ignore: cast_nullable_to_non_nullable
          : mentionedUsers as List<UserReference>?,
      nsfw: nsfw == const $CopyWithPlaceholder() || nsfw == null
          ? _value.nsfw
          // ignore: cast_nullable_to_non_nullable
          : nsfw as bool,
      pinned: pinned == const $CopyWithPlaceholder() || pinned == null
          ? _value.pinned
          // ignore: cast_nullable_to_non_nullable
          : pinned as bool,
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
      repeatCount:
          repeatCount == const $CopyWithPlaceholder() || repeatCount == null
              ? _value.repeatCount
              // ignore: cast_nullable_to_non_nullable
              : repeatCount as int,
      repeatOf: repeatOf == const $CopyWithPlaceholder()
          ? _value.repeatOf
          // ignore: cast_nullable_to_non_nullable
          : repeatOf as Post<dynamic>?,
      repeated: repeated == const $CopyWithPlaceholder() || repeated == null
          ? _value.repeated
          // ignore: cast_nullable_to_non_nullable
          : repeated as bool,
      replyCount:
          replyCount == const $CopyWithPlaceholder() || replyCount == null
              ? _value.replyCount
              // ignore: cast_nullable_to_non_nullable
              : replyCount as int,
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
