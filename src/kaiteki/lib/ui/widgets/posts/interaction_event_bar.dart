import 'package:flutter/material.dart';
import 'package:kaiteki/fediverse/model/user.dart';
import 'package:kaiteki/ui/widgets/posts/avatar_widget.dart';
import 'package:kaiteki/utils/text/text_renderer.dart';
import 'package:kaiteki/utils/text/text_renderer_theme.dart';
import 'package:kaiteki/utils/utils.dart';

/// A row that details an interaction for use in timelines
class InteractionEventBar extends StatelessWidget {
  final Color color;
  final String text;
  final IconData icon;
  final User user;
  final TextStyle userTextStyle;
  final TextStyle? textStyle;

  const InteractionEventBar({
    required this.color,
    required this.icon,
    required this.text,
    required this.user,
    required this.userTextStyle,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    var avatarMargin = const EdgeInsets.only(
      left: 28,
      right: 16,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      child: Row(
        children: [
          Padding(
            padding: avatarMargin,
            child: AvatarWidget(user, size: 16),
          ),
          Text.rich(
            TextSpan(
              style: textStyle,
              children: [
                TextRenderer(
                  emojis: user.emojis,
                  theme: TextRendererTheme.fromContext(context),
                ).renderFromHtml(context, user.displayName),
                const TextSpan(text: " "),
                WidgetSpan(
                  child: Icon(
                    icon,
                    size: Utils.getLocalFontSize(context) * 1.25,
                    color: color,
                  ),
                ),
                const TextSpan(text: " "),
                TextSpan(text: text),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
