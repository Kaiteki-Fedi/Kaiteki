import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/ui/shared/posts/avatar_widget.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/model.dart";
import "package:kaiteki_core/utils.dart";

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

    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 6, 11, 6),
      child: Row(
        children: [
          Icon(Icons.repeat_rounded, color: color, size: 18),
          const SizedBox(width: 8),
          AvatarWidget(user, size: 16),
          const SizedBox(width: 8),
          Flexible(
            child: Text.rich(
              TextSpan(
                children: [
                  user.renderDisplayName(context, ref),
                  const TextSpan(text: " "),
                  TextSpan(text: text),
                ],
              ),
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
