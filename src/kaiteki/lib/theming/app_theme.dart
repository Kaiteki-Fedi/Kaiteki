import 'package:flutter/material.dart';

class AppTheme {
  final Color linkColor;
  final Color repeatColor;
  final Color favoriteColor;

  final ChatMessageTheme incomingChatMessage;
  final ChatMessageTheme outgoingChatMessage;

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
  });
}

class ChatMessageTheme {
  final Color background;
  final Color border;

  const ChatMessageTheme({this.background, this.border});
}