import "package:kaiteki/exceptions/http_exception.dart";
import "package:kaiteki/utils/utils.dart";

class MisskeyException extends HttpException {
  final JsonMap _error;

  String get code => _error["code"] as String;
  String get message => _error["message"] as String;

  MisskeyException(super.statusCode, this._error);

  @override
  String toString() => "$code: $message";
}
