import 'package:flutter/material.dart';

class SeparatorText extends StatelessWidget {
  final String text;

  const SeparatorText(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Text(
        this.text.toUpperCase(),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).textTheme.bodyText1.color.withOpacity(.75),
        ),
      ),
    );
  }
}
