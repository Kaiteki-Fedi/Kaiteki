import 'package:kaiteki/fediverse/model/formatting.dart';

abstract class AdapterCapabilities {
  /// Specifies whether the adapter supports post scopes (i.e. visibilities).
  bool get supportsScopes;

  /// Specifies whether the adapter supports submitting posts with subjects
  /// (canonically known as content warnings).
  bool get supportsSubjects;

  List<Formatting> get supportedFormattings;

  const AdapterCapabilities();
}
