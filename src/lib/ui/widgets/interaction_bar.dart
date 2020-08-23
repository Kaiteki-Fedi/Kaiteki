import 'package:flutter/material.dart';
import 'package:kaiteki/TextRenderer.dart';
import 'package:kaiteki/api/model/mastodon/account.dart';
import 'package:kaiteki/ui/widgets/avatar_widget.dart';

/// A row that details an interaction for use in timelines
class InteractionBar extends StatelessWidget {
  final Color color;
  final String text;
  final IconData icon;
  final MastodonAccount account;

  const InteractionBar({
    @required this.color,
    @required this.icon,
    @required this.text,
    @required this.account,
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
              this.account,
              size: 16
            ),
          ),
          RichText(
            text: TextSpan(
              //style: textStyle.copyWith(fontWeight: FontWeight.bold),
              children: [
                TextRenderer(
                  emojis: this.account.emojis,
                  //textStyle: textStyle.copyWith(fontWeight: FontWeight.bold),
                ).render(this.account.displayName),
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
