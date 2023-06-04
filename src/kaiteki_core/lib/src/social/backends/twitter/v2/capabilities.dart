import 'package:kaiteki_core/social.dart';

class TwitterCapabilities extends AdapterCapabilities {
  const TwitterCapabilities();

  @override
  Set<Formatting> get supportedFormattings => const {Formatting.plainText};

  @override
  Set<Visibility> get supportedScopes {
    return const {
      Visibility.public, /* Visibility.circle */
    };
  }

  @override
  bool get supportsSubjects => false;

  @override
  Set<TimelineKind> get supportedTimelines => const {TimelineKind.home};
}
