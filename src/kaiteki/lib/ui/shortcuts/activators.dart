import "package:flutter/services.dart" show LogicalKeyboardKey;
import "package:flutter/widgets.dart"
    show CharacterActivator, LogicalKeySet, ShortcutActivator, SingleActivator;

/// List of [ShortcutActivator]s that should not be triggered in text input
/// scenarios.
final propagatingTextFieldActivators = <ShortcutActivator>[
  newPost,
  gotoHome,
  gotoBookmarks,
  gotoNotifications,
  gotoSettings
];

const openMenu = SingleActivator(LogicalKeyboardKey.contextMenu);

const newPost = SingleActivator(
  LogicalKeyboardKey.keyN,
  includeRepeats: false,
);
const reply = SingleActivator(
  LogicalKeyboardKey.keyR,
  includeRepeats: false,
);
const repeat = SingleActivator(
  LogicalKeyboardKey.keyT,
  includeRepeats: false,
);
const favorite = SingleActivator(
  LogicalKeyboardKey.keyL,
  includeRepeats: false,
);
const bookmark = SingleActivator(
  LogicalKeyboardKey.keyB,
  includeRepeats: false,
);
const menu = SingleActivator(LogicalKeyboardKey.contextMenu);
const commit = SingleActivator(LogicalKeyboardKey.enter, control: true);
final gotoHome = LogicalKeySet(
  LogicalKeyboardKey.keyG,
  LogicalKeyboardKey.keyH,
);
final gotoNotifications = LogicalKeySet(
  LogicalKeyboardKey.keyG,
  LogicalKeyboardKey.keyN,
);
final gotoSettings = LogicalKeySet(
  LogicalKeyboardKey.keyG,
  LogicalKeyboardKey.keyS,
);
final gotoBookmarks = LogicalKeySet(
  LogicalKeyboardKey.keyG,
  LogicalKeyboardKey.keyB,
);
const openLauncher = SingleActivator(LogicalKeyboardKey.keyK, control: true);
const shortcutsHelp = CharacterActivator("?");
const refresh = SingleActivator(LogicalKeyboardKey.f5);
const refresh2 = SingleActivator(LogicalKeyboardKey.keyR, control: true);
const refresh3 = SingleActivator(LogicalKeyboardKey.browserRefresh);
