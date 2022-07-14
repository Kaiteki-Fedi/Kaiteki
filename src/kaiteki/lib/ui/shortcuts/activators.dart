import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter/widgets.dart'
    show CharacterActivator, LogicalKeySet, SingleActivator;

const newPost = SingleActivator(LogicalKeyboardKey.keyN);
const reply = SingleActivator(LogicalKeyboardKey.keyR);
const repeat = SingleActivator(LogicalKeyboardKey.keyT);
const favorite = SingleActivator(LogicalKeyboardKey.keyL);
const bookmark = SingleActivator(LogicalKeyboardKey.keyB);
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
const shortcutsHelp = CharacterActivator('?');
const refresh = SingleActivator(LogicalKeyboardKey.f5);
const refresh2 = SingleActivator(LogicalKeyboardKey.keyR, control: true);
const refresh3 = SingleActivator(LogicalKeyboardKey.browserRefresh);
