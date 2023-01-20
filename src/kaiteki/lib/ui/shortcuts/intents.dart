import "package:flutter/widgets.dart";

class NewPostIntent extends Intent {
  const NewPostIntent();
}

class ReplyIntent extends Intent {
  const ReplyIntent();
}

class RepeatIntent extends Intent {
  const RepeatIntent();
}

class FavoriteIntent extends Intent {
  const FavoriteIntent();
}

class BookmarkIntent extends Intent {
  const BookmarkIntent();
}

class ReactIntent extends Intent {
  const ReactIntent();
}

class OpenMenuIntent extends Intent {
  const OpenMenuIntent();
}

class SendIntent extends Intent {
  const SendIntent();
}

class RefreshIntent extends Intent {
  const RefreshIntent();
}

class GoToAppLocationIntent extends Intent {
  final AppLocation location;

  const GoToAppLocationIntent(this.location);
}

enum AppLocation { home, notifications, profile, settings, bookmarks }

class ShortcutsHelpIntent extends Intent {
  const ShortcutsHelpIntent();
}
