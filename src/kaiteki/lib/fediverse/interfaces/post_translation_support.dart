import "package:kaiteki/fediverse/model/post/post.dart";

abstract class PostTranslationSupport {
  Future<Post> translatePost(Post post, String targetLanguage);
}
