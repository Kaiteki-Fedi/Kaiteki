// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PostStateCWProxy {
  PostState bookmarked(bool bookmarked);

  PostState favorited(bool favorited);

  PostState pinned(bool pinned);

  PostState repeated(bool repeated);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PostState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PostState(...).copyWith(id: 12, name: "My name")
  /// ````
  PostState call({
    bool? bookmarked,
    bool? favorited,
    bool? pinned,
    bool? repeated,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPostState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPostState.copyWith.fieldName(...)`
class _$PostStateCWProxyImpl implements _$PostStateCWProxy {
  final PostState _value;

  const _$PostStateCWProxyImpl(this._value);

  @override
  PostState bookmarked(bool bookmarked) => this(bookmarked: bookmarked);

  @override
  PostState favorited(bool favorited) => this(favorited: favorited);

  @override
  PostState pinned(bool pinned) => this(pinned: pinned);

  @override
  PostState repeated(bool repeated) => this(repeated: repeated);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PostState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PostState(...).copyWith(id: 12, name: "My name")
  /// ````
  PostState call({
    Object? bookmarked = const $CopyWithPlaceholder(),
    Object? favorited = const $CopyWithPlaceholder(),
    Object? pinned = const $CopyWithPlaceholder(),
    Object? repeated = const $CopyWithPlaceholder(),
  }) {
    return PostState(
      bookmarked:
          bookmarked == const $CopyWithPlaceholder() || bookmarked == null
              ? _value.bookmarked
              // ignore: cast_nullable_to_non_nullable
              : bookmarked as bool,
      favorited: favorited == const $CopyWithPlaceholder() || favorited == null
          ? _value.favorited
          // ignore: cast_nullable_to_non_nullable
          : favorited as bool,
      pinned: pinned == const $CopyWithPlaceholder() || pinned == null
          ? _value.pinned
          // ignore: cast_nullable_to_non_nullable
          : pinned as bool,
      repeated: repeated == const $CopyWithPlaceholder() || repeated == null
          ? _value.repeated
          // ignore: cast_nullable_to_non_nullable
          : repeated as bool,
    );
  }
}

extension $PostStateCopyWith on PostState {
  /// Returns a callable class that can be used as follows: `instanceOfPostState.copyWith(...)` or like so:`instanceOfPostState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PostStateCWProxy get copyWith => _$PostStateCWProxyImpl(this);
}
