import "package:flutter/material.dart";

class TextWithIcon extends StatelessWidget {
  final Widget icon;
  final Widget text;

  const TextWithIcon({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        const SizedBox(width: 8.0),
        text,
      ],
    );
  }
}
