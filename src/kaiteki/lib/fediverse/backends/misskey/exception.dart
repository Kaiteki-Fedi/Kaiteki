import 'package:fediverse_objects/misskey.dart';
import 'package:kaiteki/exceptions/api_exception.dart';

class MisskeyException extends ApiException {
  final Error error;

  MisskeyException(int statusCode, this.error) : super(statusCode);

  @override
  String toString() {
    // FIXME(Craftplacer): Wrong fields have been generated for Error
    // if (error.error["message"] != null) {
    //   return error.error["message"];
    // }

    return super.toString();
  }
}
