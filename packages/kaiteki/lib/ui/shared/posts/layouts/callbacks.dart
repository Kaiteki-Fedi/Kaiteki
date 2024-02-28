import "package:flutter/foundation.dart";

@immutable
class InteractionCallbacks {
  final InteractionCallback onReply;
  final InteractionCallback onRepeat;
  final InteractionCallback onFavorite;
  final InteractionCallback onReact;
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

sealed class InteractionCallback {
  VoidCallback? get callback;

  const factory InteractionCallback(VoidCallback callback) =
      NormalInteractionCallback;
  const InteractionCallback._();
  const factory InteractionCallback.unavailable() =
      UnavailableInteractionCallback;
  const factory InteractionCallback.disabled() = DisabledInteractionCallback;
}

/// Action is available
class NormalInteractionCallback extends InteractionCallback {
  @override
  final VoidCallback callback;

  const NormalInteractionCallback(this.callback) : super._();
}

/// Action is hidden
class UnavailableInteractionCallback extends InteractionCallback {
  const UnavailableInteractionCallback() : super._();

  @override
  Null get callback => null;
}

/// Action is disabled, "greyed-out"
class DisabledInteractionCallback extends InteractionCallback {
  @override
  Null get callback => null;

  const DisabledInteractionCallback() : super._();
}
