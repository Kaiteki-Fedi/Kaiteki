import "package:flutter/material.dart";
import "package:fpdart/fpdart.dart";

@immutable
class InteractionCallbacks {
  final Option<VoidCallback?> onReply;
  final Option<VoidCallback?> onRepeat;
  final Option<VoidCallback?> onFavorite;
  final Option<VoidCallback?> onReact;
  final VoidCallback? onShowRepeatees;
  final VoidCallback? onShowFavoritees;
  final VoidCallback? onShowMenu;

  const InteractionCallbacks({
    required this.onReply,
    required this.onRepeat,
    required this.onFavorite,
    required this.onShowRepeatees,
    required this.onShowFavoritees,
    required this.onReact,
    required this.onShowMenu,
  });
}
