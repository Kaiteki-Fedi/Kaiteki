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
    println(color('[$category] ${event.message}'));
  }
}