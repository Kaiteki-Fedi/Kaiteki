import 'package:flutter/material.dart';
import 'package:kaiteki/theming/theme_container.dart';
import 'package:kaiteki/theming/toggle_button_theme.dart';
import 'package:provider/provider.dart';

class AppTheme {
  final Color repeatColor;
  final Color favoriteColor;

  final ChatMessageTheme incomingChatMessage;
  final ChatMessageTheme outgoingChatMessage;

  final ToggleButtonTheme reactionButtonTheme;

  final Color borderColor;
  final Color textColor;

  final TextStyle linkTextStyle;

  final double chatMessageRounding;

  final ThemeData materialTheme;

  const AppTheme({
    required this.materialTheme,
    required this.linkTextStyle,
    required this.repeatColor,
    required this.favoriteColor,
    required this.borderColor,
    required this.textColor,
    required this.incomingChatMessage,
    required this.outgoingChatMessage,
    required this.chatMessageRounding,
    required this.reactionButtonTheme,
  });

  static AppTheme of(BuildContext context, {bool listen = false}) {
    var container = Provider.of<ThemeContainer>(context, listen: listen);
    return container.current;
  }
}

class ChatMessageTheme {
  final Color background;
  final Color border;

  const ChatMessageTheme({
    required this.background,
    required this.border,
  });

  ChatMessageTheme.from(ThemeData materialTheme)
      : background = materialTheme.cardColor,
        border = materialTheme.dividerColor;
}
