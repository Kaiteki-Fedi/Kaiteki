import "package:flutter/material.dart";
import "package:kaiteki/ui/plain_text_screen.dart";

class StackTraceScreen extends StatelessWidget {
  final StackTrace stackTrace;

  const StackTraceScreen({super.key, required this.stackTrace});

  @override
  Widget build(BuildContext context) {
    return PlainTextScreen(
      stackTrace.toString(),
      title: const Text("Stack Trace"),
    );
  }
}
