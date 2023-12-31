import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/app_preferences.dart";
import "package:kaiteki/theming/colors.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki/ui/shared/posts/count_button.dart";
import "package:kaiteki/ui/shared/posts/layouts/layout.dart";
import "package:kaiteki_core/kaiteki_core.dart";

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

    var buttons = <Widget>[
      if (callbacks.onReply.isSome())
        _ReplyButton.infer(
          callbacks: callbacks,
          metrics: widget.metrics,
          showLabel: widget.showLabels,
        ),
      if (callbacks.onRepeat.isSome())
        if (true)
          _RepeatButton(
            onTap: callbacks.onRepeat.toNullable(),
            showLabel: widget.showLabels,
            count: widget.metrics.repeatCount,
          )
        else
          // ignore: dead_code
          MenuAnchor(
            builder: (context, controller, _) {
              return _RepeatButton(
                onTap: controller.open,
                showLabel: widget.showLabels,
                count: widget.metrics.repeatCount,
              );
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
        _FavoriteButton.infer(
          callbacks: callbacks,
          isFavorited: widget.favorited ?? false,
          metrics: widget.metrics,
          showLabel: widget.showLabels,
        ),
      if (callbacks.onReact.isSome())
        _ReactButton.infer(
          callbacks: callbacks,
          metrics: widget.metrics,
          showLabel: widget.showLabels,
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
          tooltip: context.materialL10n.moreButtonTooltip,
          icon: Icon(
            Icons.more_horiz,
            color: theme.getEmphasisColor(EmphasisColor.medium),
            size: 20,
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
}

class _ReplyButton extends ConsumerWidget {
  final VoidCallback? onTap;
  final bool showLabel;
  final int? count;

  const _ReplyButton({
    this.showLabel = true,
    required this.onTap,
    required this.count,
  });

  factory _ReplyButton.infer({
    required InteractionCallbacks callbacks,
    required PostMetrics metrics,
    bool showLabel = true,
  }) {
    return _ReplyButton(
      onTap: callbacks.onReply.toNullable(),
      showLabel: showLabel,
      count: metrics.replyCount,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CountButton(
      count: count,
      focusNode: FocusNode(skipTraversal: true),
      icon: const Icon(Icons.reply_rounded),
      onTap: onTap,
      labelStyle: _getLabelStyle(showLabel, ref.watch(showReplyCounts).value),
      label: context.l10n.replyButtonLabel,
      semanticsLabel: count.nullTransform(context.l10n.replyCount),
    );
  }
}

class _FavoriteButton extends ConsumerWidget {
  final VoidCallback? onTap;
  final VoidCallback? onSecondary;
  final bool showLabel;
  final bool value;
  final int? count;

  const _FavoriteButton(
    this.value, {
    this.showLabel = true,
    required this.onTap,
    required this.onSecondary,
    required this.count,
  });

  factory _FavoriteButton.infer({
    required InteractionCallbacks callbacks,
    required bool isFavorited,
    required PostMetrics metrics,
    bool showLabel = true,
  }) {
    return _FavoriteButton(
      isFavorited,
      onTap: callbacks.onFavorite.toNullable(),
      onSecondary: callbacks.onShowFavoritees,
      showLabel: showLabel,
      count: metrics.favoriteCount,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteColor = Theme.of(context).ktkColors?.favoriteColor ??
        DefaultKaitekiColors(context).favoriteColor;
    return CountButton(
      active: value,
      activeColor: favoriteColor,
      count: count,
      focusNode: FocusNode(skipTraversal: true),
      icon: const Icon(Icons.star_border_rounded),
      onTap: onTap,
      onLongPress: onSecondary,
      label: context.l10n.favoriteButtonLabel,
      labelStyle: _getLabelStyle(showLabel, ref.watch(showReplyCounts).value),
      semanticsLabel: count.nullTransform(context.l10n.favoriteCount),
    );
  }
}

class _ReactButton extends ConsumerWidget {
  final VoidCallback? onTap;
  final bool showLabel;

  const _ReactButton({
    this.showLabel = true,
    required this.onTap,
  });

  factory _ReactButton.infer({
    required InteractionCallbacks callbacks,
    required PostMetrics metrics,
    bool showLabel = true,
  }) {
    return _ReactButton(
      onTap: callbacks.onReact.toNullable(),
      showLabel: showLabel,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CountButton(
      focusNode: FocusNode(skipTraversal: true),
      icon: const Icon(Icons.mood_rounded),
      onTap: onTap,
      labelStyle: _getLabelStyle(showLabel, ref.watch(showReplyCounts).value),
      label: context.l10n.reactButtonLabel,
    );
  }
}

class _RepeatButton extends ConsumerWidget {
  final VoidCallback? onTap;
  final bool showLabel;
  final int? count;

  const _RepeatButton({
    this.showLabel = true,
    required this.onTap,
    required this.count,
  });

  factory _RepeatButton.infer({
    required InteractionCallbacks callbacks,
    required PostMetrics metrics,
    bool showLabel = true,
  }) {
    return _RepeatButton(
      onTap: callbacks.onRepeat.toNullable(),
      showLabel: showLabel,
      count: metrics.repeatCount,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repeatColor = Theme.of(context).ktkColors?.repeatColor ??
        DefaultKaitekiColors(context).repeatColor;
    return CountButton(
      activeColor: repeatColor,
      count: count,
      focusNode: FocusNode(skipTraversal: true),
      icon: const Icon(Icons.repeat_rounded),
      onTap: onTap,
      labelStyle: _getLabelStyle(showLabel, ref.watch(showReplyCounts).value),
      label: context.l10n.repeatButtonLabel,
      semanticsLabel: count.nullTransform(context.l10n.repeatCount),
    );
  }
}

CountButtonLabelStyle _getLabelStyle(bool showLabels, bool showCounts) {
  if (showLabels == false) return CountButtonLabelStyle.none;
  return showCounts ? CountButtonLabelStyle.count : CountButtonLabelStyle.label;
}
