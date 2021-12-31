import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/model/post_filters/post_filter.dart';

/// Craftplacer's internal version of the horny jail.
class SensitivePostFilter extends PostFilter {
  @override
  PostFilterResult checkPost(WidgetRef ref, Post post) {
    final container = ref.watch(preferenceProvider);
    final prefs = container.get();
    final filterSettings = prefs.sensitivePostFilter;

    if (filterSettings.enabled) {
      final matchMarked = filterSettings.filterPostsMarkedAsSensitive;
      final matchSubject = filterSettings.filterPostsWithSubject;

      if ((matchMarked && post.nsfw) ||
          (matchSubject && post.subject?.isNotEmpty == true)) {
        return PostFilterResult.hide;
      }
    }

    return PostFilterResult.show;
  }
}
