import 'package:flutter/widgets.dart';
import 'package:kaiteki/fediverse/model/post.dart';

abstract class PostFilter {
  PostFilterResult checkPost(BuildContext context, Post post) {
    return PostFilterResult.Show;
  }

  static PostFilterResult runMultipleFilters(
    BuildContext context,
    Post post,
    Iterable<PostFilter> filters,
  ) {
    var result = PostFilterResult.Show;

    for (var filter in filters) {
      try {
        var filterResult = filter.checkPost(context, post);

        if (filterResult == PostFilterResult.Hide) {
          // We won't get any higher value/punishment, so we end here
          return PostFilterResult.Hide;
        } else if (filterResult == PostFilterResult.Collapse) {
          filterResult = PostFilterResult.Collapse;
        }
      } catch (e) {
        // TODO: Add log message
      }
    }

    return result;
  }
}

enum PostFilterResult {
  Show,
  Collapse,
  Hide,
}
