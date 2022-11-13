import 'package:fediverse_objects/misskey.dart';
import 'package:kaiteki/exceptions/api_exception.dart';

class MisskeyException extends ApiException {
  final Error error;

  MisskeyException(super.statusCode, this.error);

  @override
  // FIXME(Craftplacer): Wrong fields have been generated for Error
  // ignore: unnecessary_overrides
  String toString() {
    // if (error.error["message"] != null) {
    //   return error.error["message"];
    // }

    return super.toString();
  }
}
