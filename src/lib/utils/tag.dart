import 'package:kaiteki/utils/text_buffer.dart';

class Tag {
  String name;
  Map<String, String> attributes = <String, String>{};
  bool isClosing = false;

  Tag.parse(String source) {
    var buffer = TextBuffer();

    var insideString = false;

    String tempName;
    String currentAttributeName;

    void finish() {
      if (tempName == null)
        return;

      if (name == null) {
        name = tempName;
      } else if (currentAttributeName != null) {
        attributes[currentAttributeName] = tempName;
        currentAttributeName = null;
      } else {
        attributes[tempName] = null;
      }

      tempName = null;
    }

    void setTemp() {
      if (buffer.text.isNotEmpty)
        tempName = buffer.cut();
    }

    for (var i = 0; i < source.length; i++) {
      switch (source[i]) {
        case '/': {
          if (i == 0 || i == source.length - 1) {
            isClosing = true;
            break;
          }

          continue;
        }
        case '\"': {
          if (insideString) {
            if (currentAttributeName != null) {
              setTemp();
              attributes[currentAttributeName] = tempName;
              currentAttributeName = null;
              tempName = null;
            } else {
              throw "Malformed tag, strings cannot be used without key preceding it.\n$source";
            }
          }

          insideString = !insideString;
          break;
        }

        case ' ': {
          if (insideString)
            continue;

          setTemp();

          break;
        }

        case '=': {
          if (insideString)
            continue;

          setTemp();

          if (tempName != null) {
            currentAttributeName = tempName;
            tempName = null;
            break;
          }

          throw "Malformed HTML, expected a character to precede the equals sign at $i";
        }

        default: {
          finish();
          buffer.append(source[i]);
        }
      }
    }

    setTemp();
    finish();
  }
}