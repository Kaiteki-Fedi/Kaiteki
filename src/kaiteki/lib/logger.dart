import 'package:logger/logger.dart';

Logger getLogger(String category) {
  return Logger(printer: KaitekiLogPrinter(category));
}

class KaitekiLogPrinter extends LogPrinter {
  final String category;

  KaitekiLogPrinter(this.category);

  @override
  List<String> log(LogEvent event) {
    final lines = <String>[];
    final color = PrettyPrinter.levelColors[event.level];

    if (event.error != null) {
      lines.add('=====');
    }

    lines.add(color!('[$category] ${event.message}'));

    if (event.error != null) {
      lines.add(event.error.toString());

      if (event.stackTrace != null) {
        lines.add(event.stackTrace.toString());
      }

      lines.add('=====');
    }

    return lines;
  }
}
