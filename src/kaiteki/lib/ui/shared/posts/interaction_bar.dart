import "package:flutter/material.dart";
import "package:kaiteki/fediverse/model/model.dart";
import "package:kaiteki/theming/kaiteki/colors.dart";
import "package:kaiteki/ui/shared/posts/count_button.dart";

class InteractionBar extends StatefulWidget {
  const InteractionBar({
    super.key,
    required this.metrics,
    this.onReply,
    this.onFavorite,
    this.onRepeat,
    this.onReact,
    this.favorited,
    this.repeated,
    this.reacted,
    required this.buildActions,
    this.onShowFavoritees,
    this.onShowRepeatees,
  });

  final PostMetrics metrics;

  final VoidCallback? onReply;
  final VoidCallback? onFavorite;
  final VoidCallback? onShowFavoritees;
  final bool? favorited;

  final VoidCallback? onRepeat;
  final VoidCallback? onShowRepeatees;

  final bool? repeated;

  final VoidCallback? onReact;
  final bool? reacted;
  final List<PopupMenuEntry> Function(BuildContext) buildActions;

  @override
  State<InteractionBar> createState() => InteractionBarState();
}

class InteractionBarState extends State<InteractionBar> {
  final _popupMenuButtonKey = GlobalKey<PopupMenuButtonState>();

  void showMenu() => _popupMenuButtonKey.currentState!.showButtonMenu();

  @override
  Widget build(BuildContext context) {
    final buttons = [
      CountButton(
        count: widget.metrics.replyCount,
        focusNode: FocusNode(skipTraversal: true),
        icon: const Icon(Icons.reply_rounded),
        onTap: widget.onReply,
      ),
      if (widget.repeated != null)
        CountButton(
          active: widget.repeated ?? false,
          activeColor: Theme.of(context).ktkColors?.repeatColor,
          count: widget.metrics.repeatCount,
          focusNode: FocusNode(skipTraversal: true),
          icon: const Icon(Icons.repeat_rounded),
          onTap: widget.onRepeat,
          onLongPress: widget.onShowRepeatees,
        ),
      if (widget.favorited != null)
        CountButton(
          active: widget.favorited ?? false,
          activeColor: Theme.of(context).ktkColors?.favoriteColor,
          activeIcon: const Icon(Icons.star_rounded),
          count: widget.metrics.likeCount,
          focusNode: FocusNode(skipTraversal: true),
          icon: const Icon(Icons.star_border_rounded),
          onTap: widget.onFavorite,
          onLongPress: widget.onShowFavoritees,
        ),
      if (widget.reacted != null)
        CountButton(
          focusNode: FocusNode(skipTraversal: true),
          icon: const Icon(Icons.mood_rounded),
          onTap: widget.onReact,
        ),
      PopupMenuButton(
        key: _popupMenuButtonKey,
        icon: const Icon(Icons.more_horiz),
        itemBuilder: widget.buildActions,
        splashRadius: 24,
      ),
    ];

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Row(
        children: [
          for (final button in buttons) Flexible(child: button),
        ],
      ),
    );
  }
}
