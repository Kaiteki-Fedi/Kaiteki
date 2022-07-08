import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaiteki/constants.dart' show dialogConstraints;
import 'package:kaiteki/ui/shared/dialogs/dialog_title_with_hero.dart';
import 'package:kaiteki/ui/shortcut_keys.dart';

class KeyboardShortcutsDialog extends StatelessWidget {
  const KeyboardShortcutsDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sectionTextStyle = TextStyle(
      color: Theme.of(context).disabledColor,
    );
    return ConstrainedBox(
      constraints: dialogConstraints,
      child: AlertDialog(
        title: const DialogTitleWithHero(
          icon: Icon(Icons.keyboard_rounded),
          title: Text("Keyboard Shortcuts"),
        ),
        scrollable: true,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            KeyboardShortcut(
              icon: const Icon(Icons.edit_rounded),
              label: const Text("Compose a new post"),
              shortcut: newPostKeySet,
            ),
            const Divider(thickness: 1, height: 23),
            Text("Post shortcuts", style: sectionTextStyle),
            KeyboardShortcut(
              icon: const Icon(Icons.reply_rounded),
              label: const Text("Reply to a post"),
              shortcut: replyKeySet,
            ),
            KeyboardShortcut(
              icon: const Icon(Icons.star_rounded),
              label: const Text("Favorite a post"),
              shortcut: favoriteKeySet,
            ),
            KeyboardShortcut(
              icon: const Icon(Icons.repeat_rounded),
              label: const Text("Repeat a post"),
              shortcut: repeatKeySet,
            ),
            KeyboardShortcut(
              icon: const Icon(Icons.bookmark_rounded),
              label: const Text("Bookmark a post"),
              shortcut: bookmarkKeySet,
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text("Close"),
                SizedBox(width: 12.0),
                KeyboardKey(LogicalKeyboardKey.escape),
              ],
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

class KeyboardShortcut extends StatelessWidget {
  final Widget? icon;
  final Widget label;
  final LogicalKeySet shortcut;

  const KeyboardShortcut({
    super.key,
    required this.label,
    required this.shortcut,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          if (icon == null)
            const SizedBox(width: 24)
          else
            IconTheme(
              data: IconThemeData(color: Theme.of(context).disabledColor),
              child: icon!,
            ),
          const SizedBox(width: 8),
          DefaultTextStyle.merge(
            style: const TextStyle(fontWeight: FontWeight.bold),
            child: label,
          ),
          const Spacer(),
          const SizedBox(width: 24),
          for (final keyboardKey in shortcut.keys) KeyboardKey(keyboardKey),
        ],
      ),
    );
  }
}

class KeyboardKey extends StatelessWidget {
  final LogicalKeyboardKey keyboardKey;

  const KeyboardKey(this.keyboardKey, {super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(4.0),
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
        child: Text(
          keyboardKey.keyLabel,
          style: GoogleFonts.robotoMono(),
        ),
      ),
    );
  }
}
