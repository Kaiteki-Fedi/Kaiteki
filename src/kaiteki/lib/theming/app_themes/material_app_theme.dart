import 'package:flutter/material.dart';
import 'package:kaiteki/theming/app_theme_source.dart';
import 'package:kaiteki/theming/app_themes/app_theme.dart';

class MaterialAppTheme implements AppThemeSource {
  final ThemeData materialTheme;

  const MaterialAppTheme(this.materialTheme);

  @override
  AppTheme toTheme() {
    var chatMessageTheme = ChatMessageTheme(
      background: materialTheme.cardColor,
      border: materialTheme.dividerColor,
    );

    return AppTheme(
      materialTheme: materialTheme,
      incomingChatMessage: chatMessageTheme,
      outgoingChatMessage: chatMessageTheme,
      chatMessageRounding: 8,
      repeatColor: Colors.greenAccent.shade200,
      favoriteColor: Colors.orangeAccent.shade200,
      linkColor: materialTheme.accentColor,
      borderColor: materialTheme.dividerColor,
      textColor: materialTheme.textTheme.bodyText1!.color!,
      reactionInactiveBackground: materialTheme.cardColor,
      reactionActiveBackground: materialTheme.accentColor,
      reactionInactiveTextStyle: materialTheme.textTheme.bodyText1!,
      reactionActiveTextStyle: materialTheme.accentTextTheme.bodyText1!,
    );
  }
}
