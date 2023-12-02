import "package:logging/logging.dart";

final _logger = Logger("MfmParser");
final _alphaNumeric = RegExp(r"\w");

enum _ParserState { dollarSign, tag, key, value, content }

typedef Region = ({
  int start,
  int end,
  String tag,
  Map<String, String?> args,
  String content,
});

/// Parses the given [input] into a list of regions containing MFM tags.
///
/// This method shouldn't throw any exceptions.
Iterable<Region> parse(String input) sync* {
  final buffer = StringBuffer();

  _ParserState? state;
  var level = 1;

  String? tag, key, value;
  final args = <String, String?>{};

  late int contentStart;
  late int start;

  /// Resets the state of the parser.
  void reset() {
    level = 1;
    state = null;
    tag = null;
    key = null;
    value = null;
    args.clear();
  }

  String clearBuffer() {
    final result = buffer.toString();
    buffer.clear();
    return result;
  }

  void commitTag() {
    assert(state == _ParserState.tag);
    assert(buffer.isNotEmpty);

    tag = clearBuffer();
  }

  void commitKey() {
    assert(state == _ParserState.key);
    assert(buffer.isNotEmpty);

    key = clearBuffer();
  }

  void commitValue() {
    assert(state == _ParserState.value);
    assert(buffer.isNotEmpty);

    value = clearBuffer();
  }

  void commitArgument() {
    assert(key != null);
    args[key!] = value;
  }

  for (var i = 0; i < input.length; i++) {
    final isBufferEmpty = buffer.isEmpty;

    final char = input[i];

    final isDot = char == ".";
    final isComma = char == ",";
    final isSpace = char == " ";
    final isOpeningBracket = char == "[";
    final isClosingBracket = char == "]";

    final isAlphaNumeric = _alphaNumeric.hasMatch(char);

    switch (state) {
      case _ParserState.tag when (isDot || isSpace) && isBufferEmpty:
      case _ParserState.key when (isComma || isSpace) && isBufferEmpty:
      case _ParserState.value when (isComma || isSpace) && isBufferEmpty:
        _logger.warning("Expected non-empty buffer in state $state");
        reset();
        break;

      case _ParserState.tag when isDot:
        commitTag();
        state = _ParserState.key;
        break;

      case _ParserState.key when isComma:
        commitKey();
        commitArgument();
        state = _ParserState.key;
        break;

      case _ParserState.value when isComma:
        commitValue();
        commitArgument();
        state = _ParserState.key;
        break;

      case _ParserState.key when isSpace:
        commitKey();
        commitArgument();
        continue parseContent;

      case _ParserState.value when isSpace:
        commitValue();
        commitArgument();
        continue parseContent;

      case _ParserState.tag when isSpace:
        commitTag();
        continue parseContent;

      parseContent:
      case _ParserState.key when isSpace:
      case _ParserState.value when isSpace:
      case _ParserState.tag when isSpace:
        contentStart = i + 1;
        state = _ParserState.content;
        break;

      case _ParserState.key when char == "=":
        commitKey();
        state = _ParserState.value;
        break;

      case _ParserState.tag when isAlphaNumeric:
      case _ParserState.key when isAlphaNumeric:
      case _ParserState.value when isAlphaNumeric || isDot:
        buffer.write(char);
        break;

      case _ParserState.content when isOpeningBracket:
        level++;
        break;

      case _ParserState.content when isClosingBracket:
        level--;

        if (level <= 0) {
          if (tag != null) {
            final content = input.substring(contentStart, i);
            yield (
              start: start,
              end: i + 1,
              tag: tag!,
              args: Map.from(args),
              content: content,
            );
          }

          reset();
          state = null;
        }
        break;

      case _ParserState.content:
        break;

      case _ParserState.dollarSign when isOpeningBracket:
        state = _ParserState.tag;
        level = 1;
        break;

      case _ParserState.dollarSign:
        _logger.warning("Expected bracket start after \$, but found $char");
        reset();
        break;

      case null when char == "\$":
        state = _ParserState.dollarSign;
        start = i;
        break;

      case null:
        break;

      default:
        _logger.warning("Unhandled state $state with char $char");
        reset();
        break;
    }
  }
}
