// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reaction.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ReactionCWProxy {
  Reaction count(int count);

  Reaction emoji(Emoji emoji);

  Reaction includesMe(bool includesMe);

  Reaction users(List<User<dynamic>>? users);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Reaction(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Reaction(...).copyWith(id: 12, name: "My name")
  /// ````
  Reaction call({
    int? count,
    Emoji? emoji,
    bool? includesMe,
    List<User<dynamic>>? users,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfReaction.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfReaction.copyWith.fieldName(...)`
class _$ReactionCWProxyImpl implements _$ReactionCWProxy {
  final Reaction _value;

  const _$ReactionCWProxyImpl(this._value);

  @override
  Reaction count(int count) => this(count: count);

  @override
  Reaction emoji(Emoji emoji) => this(emoji: emoji);

  @override
  Reaction includesMe(bool includesMe) => this(includesMe: includesMe);

  @override
  Reaction users(List<User<dynamic>>? users) => this(users: users);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Reaction(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Reaction(...).copyWith(id: 12, name: "My name")
  /// ````
  Reaction call({
    Object? count = const $CopyWithPlaceholder(),
    Object? emoji = const $CopyWithPlaceholder(),
    Object? includesMe = const $CopyWithPlaceholder(),
    Object? users = const $CopyWithPlaceholder(),
  }) {
    return Reaction(
      count: count == const $CopyWithPlaceholder() || count == null
          ? _value.count
          // ignore: cast_nullable_to_non_nullable
          : count as int,
      emoji: emoji == const $CopyWithPlaceholder() || emoji == null
          ? _value.emoji
          // ignore: cast_nullable_to_non_nullable
          : emoji as Emoji,
      includesMe:
          includesMe == const $CopyWithPlaceholder() || includesMe == null
              ? _value.includesMe
              // ignore: cast_nullable_to_non_nullable
              : includesMe as bool,
      users: users == const $CopyWithPlaceholder()
          ? _value.users
          // ignore: cast_nullable_to_non_nullable
          : users as List<User<dynamic>>?,
    );
  }
}

extension $ReactionCopyWith on Reaction {
  /// Returns a callable class that can be used as follows: `instanceOfReaction.copyWith(...)` or like so:`instanceOfReaction.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ReactionCWProxy get copyWith => _$ReactionCWProxyImpl(this);
}
