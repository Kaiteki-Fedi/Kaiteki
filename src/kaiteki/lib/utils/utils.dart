import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:kaiteki/utils/extensions.dart';

bool compareCaseInsensitive(String a, String b) =>
    a.toLowerCase() == b.toLowerCase();

String sanitizeInstance(String instance) {
  return instance.toLowerCase();
}

String withQueries(
  String baseUrl,
  Map<String, dynamic> queryParameters,
) {
  queryParameters.removeWhere((_, v) => v == null);

  if (queryParameters.isEmpty) return baseUrl;

  return '$baseUrl?${Uri(queryParameters: queryParameters).query}';
}

void checkResponse(Response response) {
  assert(
    200 <= response.statusCode && response.statusCode < 400,
    "Server returned an unsuccessful response:\n${response.body}",
  );
}

Color parseRgb(String input) {
  final startIndex = input.indexOf("(");
  final endIndex = input.indexOf(")");
  final values = input //
      .substring(startIndex, endIndex)
      .split(",")
      .map(int.parse);

  return Color.fromARGB(
    255,
    values.elementAt(0),
    values.elementAt(1),
    values.elementAt(2),
  );
}

bool isLightBackground(Color background) {
  final bgDelta = (background.red * 0.299) +
      (background.green * 0.587) +
      (background.blue * 0.114);

  return 255 - bgDelta < 105;
}

Color getReadableForeground(Color background) {
  return isLightBackground(background)
      ? const Color(0xFF000000)
      : const Color(0xFFFFFFFF);
}

double getLocalFontSize(BuildContext context) {
  return DefaultTextStyle.of(context).style.fontSize!;
}

Color getLocalTextColor(BuildContext context) {
  return DefaultTextStyle.of(context).style.color!;
}

bool isUnsuccessfulStatusCode(int code) {
  return 400 <= code && code < 600;
}

SnackBar generateAsyncSnackBar({
  required BuildContext context,
  required bool done,
  required Text text,
  required Icon icon,
  required Color? foreColor,
  SnackBarAction? action,
}) {
  return SnackBar(
    content: Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 18.0),
          child: Stack(
            children: [
              CircularProgressIndicator(value: done ? 1 : null),
              Positioned.fill(
                child: Align(
                  child: IconTheme(
                    data: IconThemeData(color: foreColor),
                    child: icon,
                  ),
                ),
              ),
            ],
          ),
        ),
        text,
      ],
    ),
    action: action,
    duration: done ? const Duration(seconds: 4) : const Duration(days: 1),
  );
}

TextStyle? getDefaultSnackBarTextStyle(BuildContext context) {
  final theme = Theme.of(context);
  final snackBarTheme = theme.snackBarTheme;

  if (snackBarTheme.contentTextStyle == null) {
    final themeData = ThemeData(brightness: theme.brightness.inverted);
    return themeData.textTheme.subtitle1;
  }

  return snackBarTheme.contentTextStyle;
}
