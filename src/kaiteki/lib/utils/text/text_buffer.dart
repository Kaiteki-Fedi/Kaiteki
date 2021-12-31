/// A class for storing and working with text
class TextBuffer {
  late String text;

  TextBuffer() {
    clear();
  }

  void prepend(String prependingText) {
    text = prependingText + text;
  }

  void append(String appendingText) {
    text += appendingText;
  }

  void clear() {
    text = '';
  }

  String cut() {
    final temp = text;
    clear();
    return temp;
  }
}
