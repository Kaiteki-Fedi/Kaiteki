export 'package:kaiteki/utils/extensions/duration.dart';
export 'package:kaiteki/utils/extensions/iterable.dart';
export 'package:kaiteki/utils/extensions/string.dart';

extension ObjectExtensions on Object? {
  TO? nullTransform<TI, TO>(TO Function(TI object) function) {
    if (this == null) return null;

    return function.call(this! as TI);
  }
}
