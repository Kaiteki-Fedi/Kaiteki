// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reaction.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ReactionCWProxy {
  Reaction emoji(Emoji emoji);

  Reaction includesMe(bool includesMe);

  Reaction count(int count);

  Reaction users(List<User<dynamic>>? users);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Reaction(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Reaction(...).copyWith(id: 12, name: "My name")
  /// ````
  Reaction call({
    Emoji? emoji,
    bool? includesMe,
    int? count,
    List<User<dynamic>>? users,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfReaction.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfReaction.copyWith.fieldName(...)`
class _$ReactionCWProxyImpl implements _$ReactionCWProxy {
  const _$ReactionCWProxyImpl(this._value);

  final Reaction _value;

  @override
  Reaction emoji(Emoji emoji) => this(emoji: emoji);

  @override
  Reaction includesMe(bool includesMe) => this(includesMe: includesMe);

  @override
  Reaction count(int count) => this(count: count);

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
    Object? emoji = const $CopyWithPlaceholder(),
    Object? includesMe = const $CopyWithPlaceholder(),
    Object? count = const $CopyWithPlaceholder(),
    Object? users = const $CopyWithPlaceholder(),
  }) {
    return Reaction(
      emoji: emoji == const $CopyWithPlaceholder() || emoji == null
          // ignore: unnecessary_non_null_assertion
          ? _value.emoji!
          // ignore: cast_nullable_to_non_nullable
          : emoji as Emoji,
      includesMe:
          includesMe == const $CopyWithPlaceholder() || includesMe == null
              // ignore: unnecessary_non_null_assertion
              ? _value.includesMe!
              // ignore: cast_nullable_to_non_nullable
              : includesMe as bool,
      count: count == const $CopyWithPlaceholder() || count == null
          // ignore: unnecessary_non_null_assertion
          ? _value.count!
          // ignore: cast_nullable_to_non_nullable
          : count as int,
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
