import 'package:flutter/material.dart';
import 'package:kaiteki/theming/theme_container.dart';
import 'package:provider/provider.dart';

class AppTheme {
  final Color linkColor;
  final Color repeatColor;
  final Color favoriteColor;

  final ChatMessageTheme incomingChatMessage;
  final ChatMessageTheme outgoingChatMessage;

  final Color reactionInactiveBackground;
  final TextStyle reactionInactiveTextStyle;

  final Color reactionActiveBackground;
  final TextStyle reactionActiveTextStyle;

  final Color borderColor;
  final Color textColor;

  final double chatMessageRounding;

  final ThemeData materialTheme;

  const AppTheme({
    this.materialTheme,
    this.linkColor,
    this.repeatColor,
    this.favoriteColor,
    this.borderColor,
    this.textColor,
    this.incomingChatMessage,
    this.outgoingChatMessage,
    this.chatMessageRounding,
    this.reactionInactiveBackground,
    this.reactionInactiveTextStyle,
    this.reactionActiveBackground,
    this.reactionActiveTextStyle,
  });

  static AppTheme of(BuildContext context, {bool listen = false}) {
    var container = Provider.of<ThemeContainer>(context, listen: listen);
    return container.current;
  }
}

class ChatMessageTheme {
  final Color background;
  final Color border;

  const ChatMessageTheme({this.background, this.border});
}
