import 'package:flutter/widgets.dart';
import 'package:kaiteki/fediverse/model/post.dart';

abstract class PostFilter {
  PostFilterResult checkPost(BuildContext context, Post post) {
    return PostFilterResult.show;
  }

  static PostFilterResult runMultipleFilters(
    BuildContext context,
    Post post,
    Iterable<PostFilter> filters,
  ) {
    var result = PostFilterResult.show;

    for (var filter in filters) {
      try {
        var filterResult = filter.checkPost(context, post);

        if (filterResult == PostFilterResult.hide) {
          // We won't get any higher value/punishment, so we end here
          return PostFilterResult.hide;
        } else if (filterResult == PostFilterResult.collapse) {
          filterResult = PostFilterResult.collapse;
        }
      } catch (e) {
        // TODO: Add log message
      }
    }

    return result;
  }
}

enum PostFilterResult {
  show,
  collapse,
  hide,
}
