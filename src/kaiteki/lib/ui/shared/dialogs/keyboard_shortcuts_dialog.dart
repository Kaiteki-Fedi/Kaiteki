import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaiteki/constants.dart' show dialogConstraints;
import 'package:kaiteki/di.dart';
import 'package:kaiteki/ui/shared/text_inherited_icon_theme.dart';
import 'package:kaiteki/ui/shortcuts/activators.dart';
import 'package:kaiteki/utils/extensions.dart';

class KeyboardShortcutsDialog extends StatelessWidget {
  const KeyboardShortcutsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final sectionTextStyle = TextStyle(
      color: Theme.of(context).disabledColor,
    );
    final l10n = context.getL10n();
    return AlertDialog(
      icon: const Icon(Icons.keyboard_rounded),
      title: Text(l10n.keyboardShortcuts),
      scrollable: true,
      actionsPadding: Theme.of(context).useMaterial3
          ? const EdgeInsets.fromLTRB(24, 24, 16, 24)
          : null,
      content: ConstrainedBox(
        constraints: dialogConstraints,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            KeyboardShortcut(
              icon: const Icon(Icons.help_rounded),
              label: Text(l10n.keyboardShortcutsOpenDialog),
              shortcuts: const [shortcutsHelp],
            ),
            const Divider(thickness: 1, height: 23),
            Text(l10n.keyboardShortcutsNavigation, style: sectionTextStyle),
            KeyboardShortcut(
              icon: const Icon(Icons.home_rounded),
              label: Text(l10n.keyboardShortcutsGoToHome),
              shortcuts: [gotoHome],
            ),
            KeyboardShortcut(
              icon: const Icon(Icons.notifications_rounded),
              label: Text(l10n.keyboardShortcutsGoToNotifications),
              shortcuts: [gotoNotifications],
            ),
            KeyboardShortcut(
              icon: const Icon(Icons.bookmark_rounded),
              label: Text(l10n.keyboardShortcutsGoToBookmarks),
              shortcuts: [gotoBookmarks],
            ),
            KeyboardShortcut(
              icon: const Icon(Icons.settings_rounded),
              label: Text(l10n.keyboardShortcutsGoToSettings),
              shortcuts: [gotoSettings],
            ),
            const Divider(thickness: 1, height: 23),
            KeyboardShortcut(
              icon: const Icon(Icons.send_rounded),
              label: Text(l10n.keyboardShortcutsSubmitPost),
              shortcuts: const [commit],
            ),
            KeyboardShortcut(
              icon: const Icon(Icons.refresh_rounded),
              label: Text(l10n.keyboardShortcutsRefreshView),
              shortcuts: const [refresh, refresh2, refresh3],
            ),
            KeyboardShortcut(
              icon: const Icon(Icons.edit_rounded),
              label: Text(l10n.keyboardShortcutsComposePost),
              shortcuts: const [newPost],
            ),
            const Divider(thickness: 1, height: 23),
            Text(l10n.keyboardShortcutsPostShortcuts, style: sectionTextStyle),
            KeyboardShortcut(
              icon: const Icon(Icons.reply_rounded),
              label: Text(l10n.keyboardShortcutsReplyToPost),
              shortcuts: const [reply],
            ),
            KeyboardShortcut(
              icon: const Icon(Icons.star_rounded),
              label: Text(l10n.keyboardShortcutsFavoritePost),
              shortcuts: const [favorite],
            ),
            KeyboardShortcut(
              icon: const Icon(Icons.repeat_rounded),
              label: Text(l10n.keyboardShortcutsRepeatPost),
              shortcuts: const [repeat],
            ),
            KeyboardShortcut(
              icon: const Icon(Icons.bookmark_rounded),
              label: Text(l10n.keyboardShortcutsBookmarkPost),
              shortcuts: const [bookmark],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.closeButtonLabel),
              const SizedBox(width: 12.0),
              KeyboardKey.fromKey(context, LogicalKeyboardKey.escape),
            ],
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
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
                .map((s) => buildKeyCombination(context, s))
                .toList()
                .joinNonString([const Text(" / ")])
                .expand((e) => e)
                .toList(),
          ),
        ],
      ),
    );
  }

  List<Widget> buildKeyCombination(
    BuildContext context,
    ShortcutActivator activator,
  ) {
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
        .map<Widget>((k) => KeyboardKey.fromKey(context, k))
        .toList()
        .joinNonString(const Text(" + "));
  }
}

class KeyboardKey extends StatelessWidget {
  final String? text;
  final Icon? icon;

  const KeyboardKey.icon(this.icon, {super.key}) : text = null;

  const KeyboardKey.text(this.text, {super.key}) : icon = null;

  factory KeyboardKey.fromKey(
    BuildContext context,
    LogicalKeyboardKey keyboardKey, {
    Key? key,
  }) {
    if (keyboardKey == LogicalKeyboardKey.browserRefresh) {
      return KeyboardKey.icon(const Icon(Icons.refresh_rounded), key: key);
    }

    final mL10n = MaterialLocalizations.of(context);
    final localizationMappings = {
      LogicalKeyboardKey.control: mL10n.keyboardKeyControl,
      LogicalKeyboardKey.escape: mL10n.keyboardKeyEscape,
    };
    final keyLabel = localizationMappings[keyboardKey];
    if (localizationMappings.containsKey(keyboardKey)) {
      return KeyboardKey.text(keyLabel, key: key);
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
