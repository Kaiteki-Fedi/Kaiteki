import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaiteki/constants.dart' show dialogConstraints;
import 'package:kaiteki/ui/shared/dialogs/dialog_title_with_hero.dart';
import 'package:kaiteki/ui/shared/text_inherited_icon_theme.dart';
import 'package:kaiteki/ui/shortcuts/activators.dart';
import 'package:kaiteki/utils/extensions.dart';

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const KeyboardShortcut(
              icon: Icon(Icons.help_rounded),
              label: Text("Open keyboard shortcuts"),
              shortcuts: [shortcutsHelp],
            ),
            const Divider(thickness: 1, height: 23),
            Text("Navigation", style: sectionTextStyle),
            KeyboardShortcut(
              icon: const Icon(Icons.home_rounded),
              label: const Text("Go to home"),
              shortcuts: [gotoHome],
            ),
            KeyboardShortcut(
              icon: const Icon(Icons.notifications_rounded),
              label: const Text("Go to notifications"),
              shortcuts: [gotoNotifications],
            ),
            KeyboardShortcut(
              icon: const Icon(Icons.bookmark_rounded),
              label: const Text("Go to bookmarks"),
              shortcuts: [gotoBookmarks],
            ),
            KeyboardShortcut(
              icon: const Icon(Icons.settings_rounded),
              label: const Text("Go to settings"),
              shortcuts: [gotoSettings],
            ),
            const Divider(thickness: 1, height: 23),
            const KeyboardShortcut(
              icon: Icon(Icons.send_rounded),
              label: Text("Submit post"),
              shortcuts: [commit],
            ),
            const KeyboardShortcut(
              icon: Icon(Icons.refresh_rounded),
              label: Text("Refresh view"),
              shortcuts: [refresh, refresh2, refresh3],
            ),
            const KeyboardShortcut(
              icon: Icon(Icons.edit_rounded),
              label: Text("Compose a new post"),
              shortcuts: [newPost],
            ),
            const Divider(thickness: 1, height: 23),
            Text("Post shortcuts", style: sectionTextStyle),
            const KeyboardShortcut(
              icon: Icon(Icons.reply_rounded),
              label: Text("Reply to a post"),
              shortcuts: [reply],
            ),
            const KeyboardShortcut(
              icon: Icon(Icons.star_rounded),
              label: Text("Favorite a post"),
              shortcuts: [favorite],
            ),
            const KeyboardShortcut(
              icon: Icon(Icons.repeat_rounded),
              label: Text("Repeat a post"),
              shortcuts: [repeat],
            ),
            const KeyboardShortcut(
              icon: Icon(Icons.bookmark_rounded),
              label: Text("Bookmark a post"),
              shortcuts: [bookmark],
            ),
          ],
        ),
        actionsPadding: Theme.of(context).useMaterial3 //
            ? const EdgeInsets.only(right: -12)
            : EdgeInsets.zero,
        actions: [
          TextButton(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Close"),
                const SizedBox(width: 12.0),
                KeyboardKey.fromKey(LogicalKeyboardKey.escape),
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
  final List<ShortcutActivator> shortcuts;

  const KeyboardShortcut({
    super.key,
    required this.label,
    required this.shortcuts,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
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
          // HACK(Craftplacer): Janky code, looks pretty much inefficient, could be refactored to perform better.
          Row(
            children: shortcuts
                .map(buildKeyCombination)
                .toList()
                .joinNonString([const Text(" / ")])
                .expand((e) => e)
                .toList(),
          ),
        ],
      ),
    );
  }

  List<Widget> buildKeyCombination(ShortcutActivator activator) {
    if (activator is CharacterActivator) {
      return [KeyboardKey.text(activator.character)];
    }

    final Set<LogicalKeyboardKey> keys;

    if (activator is SingleActivator) {
      keys = {
        if (activator.control) LogicalKeyboardKey.control,
        if (activator.alt) LogicalKeyboardKey.alt,
        if (activator.shift) LogicalKeyboardKey.shift,
        activator.trigger,
      };
    } else if (activator is LogicalKeySet) {
      keys = activator.keys;
    } else {
      throw UnimplementedError();
    }

    return keys
        .map<Widget>(KeyboardKey.fromKey)
        .toList()
        .joinNonString(const Text(" + "));
  }
}

class KeyboardKey extends StatelessWidget {
  final String? text;
  final Icon? icon;

  const KeyboardKey.icon(this.icon, {super.key}) : text = null;

  const KeyboardKey.text(this.text, {super.key}) : icon = null;

  factory KeyboardKey.fromKey(LogicalKeyboardKey keyboardKey, {Key? key}) {
    if (keyboardKey == LogicalKeyboardKey.browserRefresh) {
      return KeyboardKey.icon(const Icon(Icons.refresh_rounded), key: key);
    } else if (keyboardKey == LogicalKeyboardKey.control) {
      return KeyboardKey.text("Ctrl", key: key);
    }

    return KeyboardKey.text(keyboardKey.keyLabel);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
      borderRadius: BorderRadius.circular(4.0),
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
        child: _getKeyWidget(),
      ),
    );
  }

  Widget _getKeyWidget() {
    if (icon != null) {
      return TextInheritedIconTheme(child: icon!);
    }

    if (text != null) {
      return Text(
        text!,
        style: GoogleFonts.robotoMono(),
      );
    }

    throw UnimplementedError();
  }
}
