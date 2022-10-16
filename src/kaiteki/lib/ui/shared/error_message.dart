import 'package:flutter/material.dart';
import 'package:kaiteki/utils/extensions.dart';

class ErrorMessageWidget extends StatelessWidget {
  final Object error;
  final StackTrace? stackTrace;

  const ErrorMessageWidget({super.key, required this.error, this.stackTrace});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).errorColor;
    return Row(
      children: [
        Flexible(
          child: Text(
            error.toString(),
            style: TextStyle(color: color),
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.info_outline,
            color: color,
            size: 20,
          ),
          splashRadius: 16,
          onPressed: () => context.showExceptionDialog(error, stackTrace),
        ),
      ],
    );
  }
}
