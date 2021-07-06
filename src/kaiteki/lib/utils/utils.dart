import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Utils {
  // Change the logic of this method in case if unexpected results occur.
  static bool compareInstance(String instanceA, String instanceB) =>
      compareCaseInsensitive(instanceA, instanceB);

  static bool compareCaseInsensitive(String a, String b) =>
      a.toLowerCase() == b.toLowerCase();

  static String sanitizeInstance(String instance) {
    instance = instance.toLowerCase();
    return instance;
  }

  static String withQueries(
    String baseUrl,
    Map<String, dynamic> queryParameters,
  ) {
    queryParameters.removeWhere((_, v) => v == null);

    if (queryParameters.isEmpty) return baseUrl;

    return baseUrl + '?' + Uri(queryParameters: queryParameters).query;
  }

  static void checkResponse(Response response) {
    var isSuccessful = 200 <= response.statusCode && response.statusCode < 400;
    assert(isSuccessful,
        "Server returned an unsuccessful response:\n${response.body}");
  }

  static Color parseRgb(String input) {
    var startIndex = input.indexOf("(");
    // var pre = input.substring(0, startIndex);
    var endIndex = input.indexOf(")");
    var values = input
        .substring(startIndex, endIndex)
        .split(",")
        .map((v) => int.parse(v));

    return Color.fromARGB(
        255, values.elementAt(0), values.elementAt(1), values.elementAt(2));
  }

  static bool isLightBackground(Color background) {
    var bgDelta = (background.red * 0.299) +
        (background.green * 0.587) +
        (background.blue * 0.114);

    return 255 - bgDelta < 105;
  }

  static Color getReadableForeground(Color background) {
    return isLightBackground(background)
        ? const Color(0xFF000000)
        : const Color(0xFFFFFFFF);
  }

  static double getLocalFontSize(BuildContext context) {
    return DefaultTextStyle.of(context).style.fontSize!;
  }

  static Color getLocalTextColor(BuildContext context) {
    return DefaultTextStyle.of(context).style.color!;
  }

  static bool isUnsuccessfulStatusCode(int code) {
    return 400 <= code && code < 600;
  }

  static SnackBar generateAsyncSnackBar({
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
                    alignment: Alignment.center,
                    child: IconTheme(
                      child: icon,
                      data: IconThemeData(color: foreColor),
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
}
