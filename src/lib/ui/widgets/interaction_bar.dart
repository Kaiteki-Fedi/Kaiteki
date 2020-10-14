import 'package:flutter/material.dart';
import 'package:kaiteki/model/fediverse/user.dart';
import 'package:kaiteki/utils/text_renderer.dart';
import 'package:kaiteki/ui/widgets/avatar_widget.dart';

/// A row that details an interaction for use in timelines
class InteractionBar extends StatelessWidget {
  final Color color;
  final String text;
  final IconData icon;
  final User user;

  const InteractionBar({
    @required this.color,
    @required this.icon,
    @required this.text,
    @required this.user,
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
            child: AvatarWidget(
              this.user,
              size: 16
            ),
          ),
          RichText(
            text: TextSpan(
              //style: textStyle.copyWith(fontWeight: FontWeight.bold),
              children: [
                TextRenderer(
                  emojis: this.user.emojis,
                  //textStyle: textStyle.copyWith(fontWeight: FontWeight.bold),
                ).render(this.user.displayName),
                WidgetSpan(
                  child: Icon(
                    this.icon,
                    size: 18,
                    color: this.color,
                  ),
                ),
                TextSpan(text: this.text)
              ]
            )
          )
        ],
      ),
    );
  }
}
