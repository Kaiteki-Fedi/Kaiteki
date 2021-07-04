import 'package:kaiteki/fediverse/model/formatting.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/fediverse/model/visibility.dart';

class PostDraft {
  final String content;
  final Visibility visibility;
  final Formatting formatting;
  final String subject;
  final Post? replyTo;

  const PostDraft({
    required this.subject,
    required this.content,
    required this.visibility,
    this.formatting = Formatting.PlainText,
    this.replyTo,
  });
}