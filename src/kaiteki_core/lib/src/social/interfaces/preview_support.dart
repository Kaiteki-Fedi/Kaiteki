
import 'package:kaiteki_core/model.dart';

abstract class PreviewSupport {
  Future<Post> getPreview(PostDraft draft);
}
