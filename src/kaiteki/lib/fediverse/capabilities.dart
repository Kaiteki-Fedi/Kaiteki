import "package:kaiteki/fediverse/model/model.dart";

abstract class AdapterCapabilities {
  /// Specifies what the adapter supports post scopes (i.e. visibilities).
  Set<Visibility> get supportedScopes;

  /// Specifies whether the adapter supports submitting posts with subjects
  /// (canonically known as content warnings).
  bool get supportsSubjects;

  Set<Formatting> get supportedFormattings;

  Set<TimelineKind> get supportedTimelines;

  /// Specifies whether the adapter supports submitting posts with a language
  bool get supportsLanguageTagging => false;

  const AdapterCapabilities();
}
