import 'package:flutter/material.dart';

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
