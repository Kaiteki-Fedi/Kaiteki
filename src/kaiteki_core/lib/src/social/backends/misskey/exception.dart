import 'package:kaiteki_core/http.dart';
import 'package:kaiteki_core/utils.dart';

class MisskeyException extends HttpException {
  final JsonMap _error;

  String get code => _error['code'] as String;
  String get message => _error['message'] as String;

  MisskeyException(super.statusCode, this._error);

  @override
  String toString() => '$code: $message';
}
