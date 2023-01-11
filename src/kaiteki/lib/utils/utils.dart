import 'package:flutter/material.dart';
import 'package:http/http.dart' show Response;
import 'package:tuple/tuple.dart';

String withQueries(
  String baseUrl,
  Map<String, dynamic> queryParameters,
) {
  queryParameters.removeWhere((_, v) => v == null);

  if (queryParameters.isEmpty) return baseUrl;

  final query = Uri(
    queryParameters: queryParameters.map((k, v) {
      return MapEntry(k, v.toString());
    }),
  ).query;
  return '$baseUrl?$query';
}

void checkResponse(Response response) {
  assert(
    200 <= response.statusCode && response.statusCode < 400,
    "Server returned an unsuccessful response:\n${response.body}",
  );
}

bool isLightBackground(Color background) {
  final bgDelta = (background.red * 0.299) +
      (background.green * 0.587) +
      (background.blue * 0.114);

  return 255 - bgDelta < 105;
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

List<Tuple2<Type, StackTrace>> collectStackTraces(dynamic error) {
  final list = <Tuple2<Type, StackTrace>>[
    if (error.stackTrace is StackTrace)
      Tuple2(error.runtimeType, error.stackTrace),
  ];

  if (error.innerError != null) {
    final children = collectStackTraces(error.innerError);
    list.addAll(children);
  }

  return list;
}
