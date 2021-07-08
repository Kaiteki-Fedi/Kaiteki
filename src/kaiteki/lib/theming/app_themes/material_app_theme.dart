import 'package:flutter/material.dart';
import 'package:kaiteki/theming/app_theme_source.dart';
import 'package:kaiteki/theming/app_themes/app_theme.dart';
import 'package:kaiteki/theming/toggle_button_theme.dart';

class MaterialAppTheme implements AppThemeSource {
  final ThemeData materialTheme;
  final TextStyle? linkTextStyle;

  const MaterialAppTheme(this.materialTheme, {this.linkTextStyle});

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
      repeatColor: Colors.greenAccent.shade400,
      favoriteColor: Colors.orangeAccent.shade400,
      linkTextStyle: linkTextStyle ??
          TextStyle(
            color: materialTheme.accentColor,
          ),
      borderColor: materialTheme.dividerColor,
      textColor: materialTheme.textTheme.bodyText1!.color!,
      reactionButtonTheme: ToggleButtonTheme.from(materialTheme),
    );
  }
}
