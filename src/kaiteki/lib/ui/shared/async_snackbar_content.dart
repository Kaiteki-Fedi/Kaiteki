import 'package:flutter/material.dart';

class AsyncSnackBarContent extends StatelessWidget {
  final Icon icon;
  final Text text;
  final bool done;
  final Widget? trailing;

  const AsyncSnackBarContent({
    Key? key,
    required this.icon,
    required this.text,
    required this.done,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 18.0),
          child: Stack(
            children: [
              CircularProgressIndicator(
                value: done ? 1 : null,
              ),
              Positioned.fill(
                child: Align(
                  child: IconTheme(
                    data: IconThemeData(
                      color: DefaultTextStyle.of(context).style.color,
                    ),
                    child: icon,
                  ),
                ),
              ),
            ],
          ),
        ),
        text,
        const Spacer(),
        if (trailing != null) trailing!,
      ],
    );
  }
}
