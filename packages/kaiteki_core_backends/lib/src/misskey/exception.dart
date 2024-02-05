import 'package:kaiteki_core/http.dart';
import 'package:fediverse_objects/misskey.dart' as misskey show Error;

class MisskeyException extends HttpException {
  final misskey.Error error;

  MisskeyException(super.statusCode, this.error);

  @override
  String toString() => '${error.code}: ${error.message}';
}
