import 'package:kaiteki_core/model.dart';

abstract class PostTranslationSupport {
  Future<Post> translatePost(Post post, String targetLanguage);
}
