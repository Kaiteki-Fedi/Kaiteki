import 'package:flutter/material.dart';

class AppTheme {
  Color linkColor;
  Color repeatColor;
  Color favoriteColor;

  Color incomingChatMessageBackgroundColor;
  Color incomingChatMessageBorderColor;
  Color outgoingChatMessageBackgroundColor;
  Color outgoingChatMessageBorderColor;

  Color borderColor;
  Color textColor;

  double chatMessageRounding;

  ThemeData materialTheme;

  AppTheme({
    this.materialTheme,
    this.linkColor,
    this.repeatColor,
    this.favoriteColor,
    this.borderColor,
    this.textColor,
    this.incomingChatMessageBackgroundColor,
    this.incomingChatMessageBorderColor,
    this.outgoingChatMessageBackgroundColor,
    this.outgoingChatMessageBorderColor,
    this.chatMessageRounding,
  });

  AppTheme.fromMaterialTheme(ThemeData materialTheme) {
    this.materialTheme = materialTheme;

    this.linkColor = materialTheme.accentColor;
    this.borderColor = materialTheme.dividerColor;
    this.textColor = materialTheme.textTheme.bodyText1.color;

    this.repeatColor = Colors.greenAccent.shade200;
    this.favoriteColor = Colors.orangeAccent.shade200;

    // Chat colors
    this.incomingChatMessageBackgroundColor = materialTheme.cardColor;
    this.outgoingChatMessageBackgroundColor = materialTheme.cardColor;

    this.incomingChatMessageBorderColor = materialTheme.dividerColor;
    this.outgoingChatMessageBorderColor = materialTheme.dividerColor;

    this.chatMessageRounding = 8;
  }
}