import "package:flutter/material.dart";
import "package:kaiteki/theming/kaiteki/colors.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki/ui/shared/posts/count_button.dart";
import "package:kaiteki_core/model.dart";

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
    this.onShowFavoritees,
    this.onShowRepeatees,
    this.showLabels = true,
    this.spread = false,
    this.menuFocusNode,
    this.onShowMenu,
  });

  final PostMetrics metrics;

  final VoidCallback? onReply;
  final VoidCallback? onFavorite;
  final VoidCallback? onShowFavoritees;
  final bool? favorited;

  final VoidCallback? onRepeat;
  final VoidCallback? onShowRepeatees;
  final VoidCallback? onShowMenu;

  final bool? repeated;
  final bool showLabels;
  final bool spread;
  final VoidCallback? onReact;
  final bool? reacted;
  final FocusNode? menuFocusNode;

  @override
  State<InteractionBar> createState() => _InteractionBarState();
}

class _InteractionBarState extends State<InteractionBar> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // ignore: omit_local_variable_types
    List<Widget> buttons = <Widget>[
      CountButton(
        count: widget.metrics.replyCount,
        focusNode: FocusNode(skipTraversal: true),
        icon: const Icon(Icons.reply_rounded),
        onTap: widget.onReply,
        showNumber: widget.showLabels,
        enabled: widget.onReply != null,
      ),
      if (widget.repeated != null)
        if (true)
          _buildRepeatButton(context, widget.onRepeat)
        else
          // Ja ich weiß
          // ignore: dead_code
          MenuAnchor(
            builder: (context, controller, _) {
              return _buildRepeatButton(context, controller.open);
            },
            menuChildren: [
              PopupMenuItem(
                onTap: widget.onRepeat,
                child: const ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.repeat_rounded),
                  title: Text("Repeat"),
                ),
              ),
            ],
          ),
      if (widget.favorited != null)
        CountButton(
          active: widget.favorited ?? false,
          activeColor: Theme.of(context).ktkColors?.favoriteColor ??
              DefaultKaitekiColors(context).favoriteColor,
          activeIcon: const Icon(Icons.star_rounded),
          count: widget.metrics.favoriteCount,
          focusNode: FocusNode(skipTraversal: true),
          icon: const Icon(Icons.star_border_rounded),
          onTap: widget.onFavorite,
          onLongPress: widget.onShowFavoritees,
          showNumber: widget.showLabels,
          enabled: widget.onFavorite != null,
        ),
      if (widget.reacted != null)
        CountButton(
          focusNode: FocusNode(skipTraversal: true),
          icon: const Icon(Icons.mood_rounded),
          onTap: widget.onReact,
          showNumber: widget.showLabels,
          enabled: widget.onReact != null,
        ),
    ];

    if (!widget.spread) {
      buttons = buttons.map<Widget>((e) => Flexible(child: e)).toList();
    }

    final onShowMenu = widget.onShowMenu;
    if (onShowMenu != null) {
      buttons.add(
        IconButton(
          focusNode: widget.menuFocusNode,
          onPressed: onShowMenu,
          icon: Icon(
            Icons.more_horiz,
            color: theme.getEmphasisColor(EmphasisColor.medium),
          ),
          splashRadius: 24,
        ),
      );
    }

    return widget.spread
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: buttons,
          )
        : ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Row(children: buttons),
          );
  }

  CountButton _buildRepeatButton(BuildContext context, VoidCallback? onTap) {
    return CountButton(
      active: widget.repeated ?? false,
      activeColor: Theme.of(context).ktkColors?.repeatColor ??
          DefaultKaitekiColors(context).repeatColor,
      count: widget.metrics.repeatCount,
      focusNode: FocusNode(skipTraversal: true),
      icon: const Icon(Icons.repeat_rounded),
      onTap: onTap,
      onLongPress: widget.onShowRepeatees,
      showNumber: widget.showLabels,
      enabled: onTap != null,
    );
  }
}
