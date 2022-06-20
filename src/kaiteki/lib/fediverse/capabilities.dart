import 'package:kaiteki/fediverse/model/formatting.dart';

abstract class AdapterCapabilities {
  /// Specifies whether the adapter supports post scopes (i.e. visibilities).
  bool get supportsScopes;

  List<Formatting> get supportedFormattings;

  const AdapterCapabilities();
}
