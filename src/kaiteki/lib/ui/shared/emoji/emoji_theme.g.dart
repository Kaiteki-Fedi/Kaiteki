// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emoji_theme.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

// ignore_for_file: annotate_overrides, unused_element

mixin _$EmojiTheme {
  EmojiTheme get _self => this as EmojiTheme;

  Iterable<Object?> get _props sync* {
    yield _self.size;
    yield _self.square;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmojiTheme &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('EmojiTheme')
        ..add('size', _self.size)
        ..add('square', _self.square))
      .toString();

  EmojiTheme copyWith({
    double? size,
    bool? square,
  }) {
    return EmojiTheme(
      size: size ?? _self.size,
      square: square ?? _self.square,
    );
  }
}
