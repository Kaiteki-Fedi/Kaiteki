import "package:flutter/material.dart";
import "package:kaiteki/theming/kaiteki/colors.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki/ui/shared/posts/count_button.dart";
import "package:kaiteki/ui/shared/posts/layouts/layout.dart";
import "package:kaiteki_core/model.dart";

class InteractionBar extends StatefulWidget {
  const InteractionBar({
    super.key,
    required this.metrics,
    required this.callbacks,
    this.favorited,
    this.repeated,
    this.showLabels = true,
    this.spread = false,
    this.menuFocusNode,
  });

  final PostMetrics metrics;
  final InteractionCallbacks callbacks;

  final bool? favorited;
  final bool? repeated;

  final bool showLabels;
  final bool spread;
  final FocusNode? menuFocusNode;

  @override
  State<InteractionBar> createState() => _InteractionBarState();
}

class _InteractionBarState extends State<InteractionBar> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final callbacks = widget.callbacks;

    // ignore: omit_local_variable_types
    final favoriteColor = Theme.of(context).ktkColors?.favoriteColor ??
        DefaultKaitekiColors(context).favoriteColor;
    var buttons = <Widget>[
      if (callbacks.onReply.isSome())
        CountButton(
          count: widget.metrics.replyCount,
          focusNode: FocusNode(skipTraversal: true),
          icon: const Icon(Icons.reply_rounded),
          onTap: callbacks.onReply.toNullable(),
          showNumber: widget.showLabels,
        ),
      if (callbacks.onRepeat.isSome())
        if (true)
          _buildRepeatButton(
            context,
            callbacks.onRepeat.toNullable(),
          )
        else
          // Ja ich weiß
          // ignore: dead_code
          MenuAnchor(
            builder: (context, controller, _) {
              return _buildRepeatButton(context, controller.open);
            },
            menuChildren: [
              PopupMenuItem(
                onTap: callbacks.onRepeat.toNullable(),
                child: const ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.repeat_rounded),
                  title: Text("Repeat"),
                ),
              ),
            ],
          ),
      if (callbacks.onFavorite.isSome())
        CountButton(
          active: widget.favorited ?? false,
          activeColor: favoriteColor,
          activeIcon: const Icon(Icons.star_rounded),
          count: widget.metrics.favoriteCount,
          focusNode: FocusNode(skipTraversal: true),
          icon: const Icon(Icons.star_border_rounded),
          onTap: callbacks.onFavorite.toNullable(),
          onLongPress: callbacks.onShowFavoritees,
          showNumber: widget.showLabels,
        ),
      if (callbacks.onReact.isSome())
        CountButton(
          focusNode: FocusNode(skipTraversal: true),
          icon: const Icon(Icons.mood_rounded),
          onTap: callbacks.onReact.toNullable(),
          showNumber: widget.showLabels,
        ),
    ];

    if (!widget.spread) {
      buttons = buttons.map<Widget>((e) => Flexible(child: e)).toList();
    }

    final onShowMenu = callbacks.onShowMenu;
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
    final repeatColor = Theme.of(context).ktkColors?.repeatColor ??
        DefaultKaitekiColors(context).repeatColor;
    return CountButton(
      active: widget.repeated ?? false,
      activeColor: repeatColor,
      count: widget.metrics.repeatCount,
      focusNode: FocusNode(skipTraversal: true),
      icon: const Icon(Icons.repeat_rounded),
      onTap: onTap,
      onLongPress: widget.callbacks.onShowRepeatees,
      showNumber: widget.showLabels,
      enabled: onTap != null,
    );
  }
}
