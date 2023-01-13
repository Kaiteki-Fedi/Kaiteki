import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/fediverse/model/user/user.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki/ui/shared/posts/avatar_widget.dart";
import "package:kaiteki/utils/extensions.dart";

/// A row that details an interaction for use in timelines
class InteractionEventBar extends ConsumerWidget {
  final Color color;
  final String text;
  final IconData icon;
  final User user;

  const InteractionEventBar({
    required this.color,
    required this.icon,
    required this.text,
    required this.user,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const avatarMargin = EdgeInsets.only(
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
              children: [
                TextSpan(children: [user.renderDisplayName(context, ref)]),
                const TextSpan(text: " "),
                WidgetSpan(
                  child: Icon(
                    icon,
                    size: getLocalFontSize(context) * 1.25,
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
