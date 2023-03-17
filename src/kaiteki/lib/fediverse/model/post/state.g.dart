// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PostStateCWProxy {
  PostState favorited(bool favorited);

  PostState repeated(bool repeated);

  PostState bookmarked(bool bookmarked);

  PostState pinned(bool pinned);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PostState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PostState(...).copyWith(id: 12, name: "My name")
  /// ````
  PostState call({
    bool? favorited,
    bool? repeated,
    bool? bookmarked,
    bool? pinned,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPostState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPostState.copyWith.fieldName(...)`
class _$PostStateCWProxyImpl implements _$PostStateCWProxy {
  const _$PostStateCWProxyImpl(this._value);

  final PostState _value;

  @override
  PostState favorited(bool favorited) => this(favorited: favorited);

  @override
  PostState repeated(bool repeated) => this(repeated: repeated);

  @override
  PostState bookmarked(bool bookmarked) => this(bookmarked: bookmarked);

  @override
  PostState pinned(bool pinned) => this(pinned: pinned);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PostState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PostState(...).copyWith(id: 12, name: "My name")
  /// ````
  PostState call({
    Object? favorited = const $CopyWithPlaceholder(),
    Object? repeated = const $CopyWithPlaceholder(),
    Object? bookmarked = const $CopyWithPlaceholder(),
    Object? pinned = const $CopyWithPlaceholder(),
  }) {
    return PostState(
      favorited: favorited == const $CopyWithPlaceholder() || favorited == null
          ? _value.favorited
          // ignore: cast_nullable_to_non_nullable
          : favorited as bool,
      repeated: repeated == const $CopyWithPlaceholder() || repeated == null
          ? _value.repeated
          // ignore: cast_nullable_to_non_nullable
          : repeated as bool,
      bookmarked:
          bookmarked == const $CopyWithPlaceholder() || bookmarked == null
              ? _value.bookmarked
              // ignore: cast_nullable_to_non_nullable
              : bookmarked as bool,
      pinned: pinned == const $CopyWithPlaceholder() || pinned == null
          ? _value.pinned
          // ignore: cast_nullable_to_non_nullable
          : pinned as bool,
    );
  }
}

extension $PostStateCopyWith on PostState {
  /// Returns a callable class that can be used as follows: `instanceOfPostState.copyWith(...)` or like so:`instanceOfPostState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PostStateCWProxy get copyWith => _$PostStateCWProxyImpl(this);
}
