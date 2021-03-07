import 'package:fediverse_objects/misskey/error.dart';
import 'package:kaiteki/fediverse/api/exceptions/api_exception.dart';

class MisskeyException extends ApiException {
  final MisskeyError error;

  MisskeyException(int statusCode, this.error) : super(statusCode);

  @override
  String toString() {
    if (error?.message != null) return error.message;

    return super.toString();
  }
}
