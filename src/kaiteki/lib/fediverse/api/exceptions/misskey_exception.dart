import 'package:fediverse_objects/misskey.dart';
import 'package:kaiteki/fediverse/api/exceptions/api_exception.dart';

class MisskeyException extends ApiException {
  final MisskeyError error;

  MisskeyException(int statusCode, this.error) : super(statusCode);

  @override
  String toString() {
    if (error?.error["message"] != null) return error?.error["message"];

    return super.toString();
  }
}
