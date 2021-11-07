import 'dart:convert';

import 'package:http/http.dart' as http;

class Response {
  final http.StreamedResponse response;

  String? _text;

  bool get isSuccessful {
    final code = response.statusCode;
    return !(400 <= code && code < 600);
  }

  int get statusCode => response.statusCode;

  Response(this.response);

  Future<String> getContentText() async {
    var text = _text;

    if (text == null) {
      text = await response.stream.bytesToString();
      _text = text;
    }

    return text;
  }

  Future<dynamic> getContentJson() async {
    final text = await getContentText();
    return jsonDecode(text);
  }
}
