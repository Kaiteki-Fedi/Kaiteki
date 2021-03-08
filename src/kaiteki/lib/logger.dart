import 'package:logger/logger.dart';

Logger getLogger(String category) {
  return Logger(printer: KaitekiLogPrinter(category));
}

class KaitekiLogPrinter extends LogPrinter {
  final String category;

  KaitekiLogPrinter(this.category);

  @override
  void log(LogEvent event) {
    var color = PrettyPrinter.levelColors[event.level];

    if (event.error != null) {
      println('=====');
    }

    println(color('[$category] ${event.message}'));

    if (event.error != null) {
      println(event.error.toString());

      if (event.stackTrace != null) {
        println(event.stackTrace.toString());
      }

      println('=====');
    }
  }
}
