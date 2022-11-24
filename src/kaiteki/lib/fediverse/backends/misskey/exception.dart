import 'package:kaiteki/exceptions/api_exception.dart';

class MisskeyException extends ApiException {
  final Map<String, dynamic> _error;

  String get code => _error["code"];
  String get message => _error["message"];

  MisskeyException(super.statusCode, this._error);

  @override
  String toString() => "$code: $message";
}
