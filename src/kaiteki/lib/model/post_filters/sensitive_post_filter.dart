import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/model/post_filters/post_filter.dart';

/// Craftplacer's internal version of the horny jail.
class SensitivePostFilter extends PostFilter {
  @override
  PostFilterResult checkPost(WidgetRef ref, Post post) {
    var container = ref.watch(preferenceProvider);
    var prefs = container.get();

    if (prefs.sensitivePostFilter.enabled) {
      var matchMarked = prefs.sensitivePostFilter.filterPostsMarkedAsSensitive;
      var matchSubject = prefs.sensitivePostFilter.filterPostsWithSubject;

      if ((matchMarked && post.nsfw) ||
          (matchSubject && post.subject?.isNotEmpty == true)) {
        return PostFilterResult.hide;
      }
    }

    return PostFilterResult.show;
  }
}
