import "package:flutter/material.dart";
import "package:kaiteki/theming/chat_message_theme.dart";
import "package:kaiteki/theming/toggle_button_theme.dart";

class KaitekiTheme extends ThemeExtension<KaitekiTheme> {
  final ChatMessageTheme chatMessageIncoming;
  final ChatMessageTheme chatMessageOutgoing;
  final double chatMessageRounding;

  const KaitekiTheme({
    required this.chatMessageIncoming,
    required this.chatMessageOutgoing,
    required this.chatMessageRounding,
  });

  factory KaitekiTheme.fromMaterialTheme(ThemeData theme) {
    final chatMessageTheme = ChatMessageTheme.from(theme);
    return KaitekiTheme(
      chatMessageIncoming: chatMessageTheme,
      chatMessageOutgoing: chatMessageTheme,
      chatMessageRounding: 8,
    );
  }

  @override
  ThemeExtension<KaitekiTheme> copyWith({
    ChatMessageTheme? chatMessageIncoming,
    ChatMessageTheme? chatMessageOutgoing,
    double? chatMessageRounding,
    ToggleButtonTheme? reactionButtonTheme,
  }) {
    return KaitekiTheme(
      chatMessageIncoming: chatMessageIncoming ?? this.chatMessageIncoming,
      chatMessageOutgoing: chatMessageOutgoing ?? this.chatMessageOutgoing,
      chatMessageRounding: chatMessageRounding ?? this.chatMessageRounding,
    );
  }

  @override
  KaitekiTheme lerp(ThemeExtension<KaitekiTheme>? other, double t) {
    if (other is! KaitekiTheme) return this;

    // TODO(Craftplacer): complete lerp
    return KaitekiTheme(
      chatMessageIncoming: chatMessageIncoming,
      chatMessageOutgoing: chatMessageOutgoing,
      chatMessageRounding: chatMessageRounding,
    );
  }
}

extension ThemeExtensions on ThemeData {
  KaitekiTheme? get ktkTheme => extension<KaitekiTheme>();
}
