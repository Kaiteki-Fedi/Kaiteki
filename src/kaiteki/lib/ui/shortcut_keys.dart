import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class ShortcutKeys {
  static final newPostKeySet = LogicalKeySet(LogicalKeyboardKey.keyN);
  static final replyKeySet = LogicalKeySet(LogicalKeyboardKey.keyR);
  static final repeatKeySet = LogicalKeySet(LogicalKeyboardKey.keyT);
  static final favoriteKeySet = LogicalKeySet(LogicalKeyboardKey.keyL);
  static final bookmarkKeySet = LogicalKeySet(LogicalKeyboardKey.keyB);
  static final menuKeySet = LogicalKeySet(LogicalKeyboardKey.contextMenu);
}
