import 'model/formatting.dart';
import 'model/timeline_type.dart';
import 'model/visibility.dart';

abstract class AdapterCapabilities {
  /// Specifies what the adapter supports post scopes (i.e. visibilities).
  Set<Visibility> get supportedScopes;

  /// Specifies whether the adapter supports submitting posts with subjects
  /// (canonically known as content warnings).
  bool get supportsSubjects;

  Set<Formatting> get supportedFormattings;

  Set<TimelineType> get supportedTimelines;

  /// Specifies the maximum amount of characters for the content within a post.
  ///
  /// If `null`, no limit is enforced or it is unknown.
  int? get maxPostContentLength => null;

  /// Specifies whether the adapter supports submitting posts with a language
  bool get supportsLanguageTagging => false;

  /// Specifies whether the adapter supports submitting posts with a poll
  /// without a duration.
  bool get supportsIndefinitePolls => false;

  const AdapterCapabilities();
}
