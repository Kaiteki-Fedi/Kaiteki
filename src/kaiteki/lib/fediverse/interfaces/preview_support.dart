import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/fediverse/model/post_draft.dart';

abstract class PreviewSupport {
  Future<Post> getPreview(PostDraft draft);
}
