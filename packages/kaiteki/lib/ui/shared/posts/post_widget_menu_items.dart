import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/theming/colors.dart";
import "package:kaiteki/ui/shortcuts/activators.dart";

class UndoTranslationMenuItem extends StatelessWidget {
  final VoidCallback? onPressed;

  const UndoTranslationMenuItem({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MenuItemButton(
      leadingIcon: const Icon(Icons.undo_rounded),
      onPressed: () => onPressed,
      child: Text(context.l10n.undoTranslateButton),
    );
  }
}

class TranslateMenuItem extends StatelessWidget {
  final VoidCallback? onPressed;

  const TranslateMenuItem({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MenuItemButton(
      onPressed: onPressed,
      leadingIcon: const Icon(Icons.translate_rounded),
      child: Text(context.l10n.translateButton),
    );
  }
}

class ShareMenuItem extends StatelessWidget {
  final VoidCallback? onPressed;

  const ShareMenuItem({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MenuItemButton(
      leadingIcon: const Icon(Icons.share_rounded),
      onPressed: onPressed,
      child: Text(context.l10n.shareButtonLabel),
    );
  }
}

class OpenInBrowserMenuItem extends StatelessWidget {
  final VoidCallback? onPressed;

  const OpenInBrowserMenuItem({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MenuItemButton(
      leadingIcon: const Icon(Icons.open_in_browser_rounded),
      onPressed: onPressed,
      child: Text(context.l10n.openInBrowserLabel),
    );
  }
}

class BookmarkMenuItem extends StatelessWidget {
  final bool bookmarked;
  final VoidCallback onPressed;

  const BookmarkMenuItem({
    super.key,
    required this.bookmarked,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return MenuItemButton(
      shortcut: bookmark,
      onPressed: onPressed,
      leadingIcon: Icon(
        bookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
        color: bookmarked ? theme.ktkColors?.bookmarkColor : null,
      ),
      child: Text(
        bookmarked ? l10n.postRemoveFromBookmarks : l10n.postAddToBookmarks,
      ),
    );
  }
}

class DebugTextRenderingMenuItem extends StatelessWidget {
  final VoidCallback? onPressed;

  const DebugTextRenderingMenuItem({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MenuItemButton(
      leadingIcon: const Icon(Icons.bug_report_rounded),
      onPressed: onPressed,
      child: const Text("Debug text rendering"),
    );
  }
}
