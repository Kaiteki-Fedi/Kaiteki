import 'dart:ui';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:kaiteki/theming/chat_message_theme.dart';
import 'package:kaiteki/theming/toggle_button_theme.dart';

class KaitekiExtension extends ThemeExtension<KaitekiExtension> {
  final ChatMessageTheme chatMessageIncoming;
  final ChatMessageTheme chatMessageOutgoing;
  final Color bookmarkColor;
  final Color borderColor;
  final Color favoriteColor;
  final Color repeatColor;
  final double chatMessageRounding;
  final double emojiScale;
  final TextStyle hashtagTextStyle;
  final TextStyle linkTextStyle;
  final TextStyle mentionTextStyle;
  final ToggleButtonTheme reactionButtonTheme;

  const KaitekiExtension({
    required this.bookmarkColor,
    required this.borderColor,
    required this.chatMessageIncoming,
    required this.chatMessageOutgoing,
    required this.chatMessageRounding,
    required this.emojiScale,
    required this.favoriteColor,
    required this.hashtagTextStyle,
    required this.linkTextStyle,
    required this.mentionTextStyle,
    required this.reactionButtonTheme,
    required this.repeatColor,
  });

  factory KaitekiExtension.material(ThemeData theme) {
    final chatMessageTheme = ChatMessageTheme.from(theme);
    final accentTextStyle = TextStyle(color: theme.colorScheme.secondary);
    return KaitekiExtension(
      bookmarkColor: Colors.pink.harmonizeWith(theme.colorScheme.primary),
      borderColor: theme.dividerColor,
      chatMessageIncoming: chatMessageTheme,
      chatMessageOutgoing: chatMessageTheme,
      chatMessageRounding: 8,
      emojiScale: 1.5,
      favoriteColor: Colors.orange.harmonizeWith(theme.colorScheme.primary),
      linkTextStyle: accentTextStyle,
      reactionButtonTheme: ToggleButtonTheme.from(theme),
      repeatColor: Colors.green.harmonizeWith(theme.colorScheme.primary),
      hashtagTextStyle: accentTextStyle,
      mentionTextStyle: accentTextStyle,
    );
  }

  @override
  ThemeExtension<KaitekiExtension> copyWith({
    ChatMessageTheme? chatMessageIncoming,
    ChatMessageTheme? chatMessageOutgoing,
    Color? bookmarkColor,
    Color? borderColor,
    Color? favoriteColor,
    Color? repeatColor,
    Color? textColor,
    double? chatMessageRounding,
    double? emojiScale,
    TextStyle? hashtagTextStyle,
    TextStyle? linkTextStyle,
    TextStyle? mentionTextStyle,
    ToggleButtonTheme? reactionButtonTheme,
  }) {
    return KaitekiExtension(
      bookmarkColor: bookmarkColor ?? this.bookmarkColor,
      borderColor: borderColor ?? this.borderColor,
      chatMessageIncoming: chatMessageIncoming ?? this.chatMessageIncoming,
      chatMessageOutgoing: chatMessageOutgoing ?? this.chatMessageOutgoing,
      chatMessageRounding: chatMessageRounding ?? this.chatMessageRounding,
      emojiScale: emojiScale ?? this.emojiScale,
      favoriteColor: favoriteColor ?? this.favoriteColor,
      linkTextStyle: linkTextStyle ?? this.linkTextStyle,
      reactionButtonTheme: reactionButtonTheme ?? this.reactionButtonTheme,
      repeatColor: repeatColor ?? this.repeatColor,
      hashtagTextStyle: hashtagTextStyle ?? this.hashtagTextStyle,
      mentionTextStyle: mentionTextStyle ?? this.mentionTextStyle,
    );
  }

  @override
  ThemeExtension<KaitekiExtension> lerp(
    ThemeExtension<KaitekiExtension>? other,
    double t,
  ) {
    if (other == null) {
      return this;
    } else if (other.type is KaitekiExtension) {
      final ext = other.type as KaitekiExtension;
      // TODO(Craftplacer): complete lerp

      return KaitekiExtension(
        bookmarkColor: Color.lerp(bookmarkColor, ext.bookmarkColor, t)!,
        borderColor: Color.lerp(borderColor, ext.borderColor, t)!,
        chatMessageIncoming: chatMessageIncoming,
        chatMessageOutgoing: chatMessageOutgoing,
        chatMessageRounding: chatMessageRounding,
        emojiScale: lerpDouble(emojiScale, ext.emojiScale, t)!,
        favoriteColor: Color.lerp(favoriteColor, ext.favoriteColor, t)!,
        linkTextStyle: TextStyle.lerp(linkTextStyle, ext.linkTextStyle, t)!,
        reactionButtonTheme: reactionButtonTheme,
        repeatColor: Color.lerp(repeatColor, ext.repeatColor, t)!,
        hashtagTextStyle: TextStyle.lerp(
          hashtagTextStyle,
          ext.hashtagTextStyle,
          t,
        )!,
        mentionTextStyle: TextStyle.lerp(
          mentionTextStyle,
          ext.mentionTextStyle,
          t,
        )!,
      );
    } else {
      return this;
    }
  }
}

extension BuildContextExtensions on BuildContext {
  KaitekiExtension? get kaitekiExtension => Theme.of(this).kaitekiExtension;
}

extension ThemeExtensions on ThemeData {
  KaitekiExtension? get kaitekiExtension => extension<KaitekiExtension>();
}
