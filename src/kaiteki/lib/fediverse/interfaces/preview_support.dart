import "package:kaiteki/fediverse/model/model.dart";

abstract class PreviewSupport {
  Future<Post> getPreview(PostDraft draft);
}
