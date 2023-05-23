import "package:equatable/equatable.dart";
import "package:kaiteki/fediverse/model/attachment.dart";
import "package:kaiteki/fediverse/model/formatting.dart";
import "package:kaiteki/fediverse/model/post/post.dart";
import "package:kaiteki/fediverse/model/visibility.dart";
import "package:kaiteki/model/file.dart";

class PostDraft extends Equatable {
  final String content;
  final Visibility visibility;
  final Formatting formatting;
  final String? subject;
  final Post? replyTo;
  final List<Attachment> attachments;
  final String? language;

  bool get isEmpty =>
      content.isEmpty && subject?.isNotEmpty != true && attachments.isEmpty;

  const PostDraft({
    required this.subject,
    required this.content,
    required this.visibility,
    this.formatting = Formatting.plainText,
    this.replyTo,
    this.attachments = const [],
    this.language,
  });

  PostDraft copyWith({
    subject,
    content,
    visibility,
    formatting,
    replyTo,
    attachments,
    language,
  }) {
    return PostDraft(
      content: content ?? this.content,
      visibility: visibility ?? this.visibility,
      formatting: formatting ?? this.formatting,
      subject: subject ?? this.subject,
      replyTo: replyTo ?? this.replyTo,
      attachments: attachments ?? this.attachments,
      language: language ?? this.language,
    );
  }

  @override
  List<Object?> get props => [
        subject,
        content,
        visibility,
        formatting,
        replyTo,
        attachments,
        language,
      ];
}

class AttachmentDraft {
  final KaitekiFile? file;
  final String? remoteId;

  /// The description of the attachment.
  final String? description;

  final bool isSensitive;

  const AttachmentDraft({
    required this.file,
    this.description,
    this.isSensitive = false,
  }) : remoteId = null;

  const AttachmentDraft.remote({
    required this.remoteId,
    this.description,
    this.isSensitive = false,
  }) : file = null;

  AttachmentDraft copyWith({
    KaitekiFile? file,
    String? description,
    bool? isSensitive,
  }) {
    return AttachmentDraft(
      file: file ?? this.file,
      description: description ?? this.description,
      isSensitive: isSensitive ?? this.isSensitive,
    );
  }
}
