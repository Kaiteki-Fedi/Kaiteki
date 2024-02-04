import 'package:cross_file/cross_file.dart';
import 'package:equatable/equatable.dart';
import 'package:kaiteki_core/model.dart';

class AttachmentDraft {
  final XFile? file;
  final String? remoteId;

  final AttachmentType? type;

  /// The description of the attachment.
  final String? description;

  final bool isSensitive;

  const AttachmentDraft({
    required this.file,
    this.description,
    this.isSensitive = false,
    this.type,
  }) : remoteId = null;

  const AttachmentDraft.remote({
    required this.remoteId,
    this.description,
    this.isSensitive = false,
    this.type,
  }) : file = null;

  AttachmentDraft copyWith({
    XFile? file,
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

class PollDraft {
  final bool allowMultipleChoices;
  final List<String> options;

  /// The duration of the poll.
  ///
  /// If null, the poll will be indefinite.
  final Deadline? deadline;

  const PollDraft({
    required this.allowMultipleChoices,
    required this.options,
    required this.deadline,
  });
}

class PostDraft extends Equatable {
  final String content;
  final PostScope visibility;
  final Formatting formatting;
  final PollDraft? poll;
  final String? subject;
  final Post? replyTo;
  final List<Attachment> attachments;
  final String? language;

  const PostDraft({
    required this.subject,
    required this.content,
    required this.visibility,
    this.formatting = Formatting.plainText,
    this.replyTo,
    this.attachments = const [],
    this.language,
    this.poll,
  });

  bool get isEmpty =>
      content.isEmpty &&
      subject?.isNotEmpty != true &&
      attachments.isEmpty &&
      poll == null;

  @override
  List<Object?> get props {
    return [
      subject,
      content,
      visibility,
      formatting,
      replyTo,
      attachments,
      language,
      poll,
    ];
  }

  PostDraft copyWith({
    subject,
    content,
    visibility,
    formatting,
    replyTo,
    attachments,
    language,
    poll,
  }) {
    return PostDraft(
      content: content ?? this.content,
      visibility: visibility ?? this.visibility,
      formatting: formatting ?? this.formatting,
      subject: subject ?? this.subject,
      replyTo: replyTo ?? this.replyTo,
      attachments: attachments ?? this.attachments,
      language: language ?? this.language,
      poll: poll ?? this.poll,
    );
  }
}
