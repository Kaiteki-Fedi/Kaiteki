import 'package:flutter/foundation.dart';
import 'package:kaiteki/constants.dart';

class AppPreferences extends ChangeNotifier {
  ButtonPlacement submitButtonLocation = ButtonPlacement.AppBar;
  TextFieldSize textFieldSize = TextFieldSize.Mobile;
  NameMode appNameMode = NameMode.Romaji;
  bool atWorkMode = true;

  String getPreferredAppName() => Constants.getPreferredAppName(appNameMode);
}

enum TextFieldSize {
  Mobile,
  Desktop
}

enum NameMode {
  Romaji,
  Hiragana,
  Katakana,
  Kanji
}

enum ButtonPlacement {
  AppBar,
  Standalone
}