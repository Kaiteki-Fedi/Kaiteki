import 'dart:ui';

import 'package:http/http.dart';

class Utils {
  // Change the logic of this method in case if unexpected results occur.
  static bool compareInstance(String instanceA, String instanceB) => compareCaseInsensitive(instanceA, instanceB);

  static bool compareCaseInsensitive(String a, String b) => a.toLowerCase() == b.toLowerCase();

  static String sanitizeInstance(String instance) {
    instance = instance.toLowerCase();
    return instance;
  }

  static void checkResponse(Response response) {
    var isSuccessful = 200 <= response.statusCode && response.statusCode < 400;
    assert(
      isSuccessful,
      "Server returned an unsuccessful response:\n${response.body}"
    );
  }



  static bool isLightBackground(Color background) {
    var bgDelta =
        (background.red * 0.299) +
        (background.green * 0.587) +
        (background.blue * 0.114);

    return 255 - bgDelta < 105;
  }

  static Color getReadableForeground(Color background) {
    return isLightBackground(background)
        ? Color(0xFF000000)
        : Color(0xFFFFFFFF);
  }
}