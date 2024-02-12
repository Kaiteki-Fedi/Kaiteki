import 'package:json_annotation/json_annotation.dart';
import 'user.dart';
import 'drive_file.dart';
import 'user_group.dart';
part 'messaging_message.g.dart';

@JsonSerializable()
class MessagingMessage {
  final String id;

  final DateTime createdAt;

  final String userId;

  final User? user;

  final String? text;

  final String? fileId;

  final DriveFile? file;

  final String? recipientId;

  final User? recipient;

  final String? groupId;

  final UserGroup? group;

  final bool? isRead;

  final List<String>? reads;

  const MessagingMessage({
    required this.id,
    required this.createdAt,
    required this.userId,
    this.user,
    this.text,
    this.fileId,
    this.file,
    this.recipientId,
    this.recipient,
    this.groupId,
    this.group,
    this.isRead,
    this.reads,
  });

  factory MessagingMessage.fromJson(Map<String, dynamic> json) =>
      _$MessagingMessageFromJson(json);
  Map<String, dynamic> toJson() => _$MessagingMessageToJson(this);
}
