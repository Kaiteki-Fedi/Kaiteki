import 'package:flutter/foundation.dart';

class AppPreferences extends ChangeNotifier {
  ButtonPlacement submitButtonLocation = ButtonPlacement.AppBar;
  TextFieldSize textFieldSize = TextFieldSize.Mobile;
  NameMode appNameMode = NameMode.Romaji;
  /// you won't get any horny today.
  bool get antiHornyMode => true;
  // hmm...
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