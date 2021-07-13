import 'package:flutter/material.dart';
import 'package:kaiteki/utils/extensions.dart';

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
    var textStyle = _getSnackBarTextStyle(context);
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
                  alignment: Alignment.center,
                  child: IconTheme(
                    child: icon,
                    data: IconThemeData(color: textStyle?.color),
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

  TextStyle? _getSnackBarTextStyle(BuildContext context) {
    final theme = Theme.of(context);
    final snackBarTheme = theme.snackBarTheme;

    if (snackBarTheme.contentTextStyle == null) {
      final themeData = ThemeData(brightness: theme.brightness.inverted);
      return themeData.textTheme.subtitle1;
    }

    return snackBarTheme.contentTextStyle;
  }
}
