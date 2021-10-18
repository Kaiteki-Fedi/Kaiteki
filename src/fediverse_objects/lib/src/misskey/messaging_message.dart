import 'package:fediverse_objects/src/misskey/drive_file.dart';
import 'package:fediverse_objects/src/misskey/user.dart';
import 'package:fediverse_objects/src/misskey/user_group.dart';
import 'package:json_annotation/json_annotation.dart';

part 'messaging_message.g.dart';

@JsonSerializable()
class MessagingMessage {
  /// The unique identifier for this MessagingMessage.
  @JsonKey(name: 'id')
  final String id;

  /// The date that the MessagingMessage was created.
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;

  @JsonKey(name: 'userId')
  final String userId;

  @JsonKey(name: 'user')
  final User user;

  @JsonKey(name: 'text')
  final String text;

  @JsonKey(name: 'fileId')
  final String fileId;

  @JsonKey(name: 'file')
  final DriveFile file;

  @JsonKey(name: 'recipientId')
  final String recipientId;

  @JsonKey(name: 'recipient')
  final User recipient;

  @JsonKey(name: 'groupId')
  final String groupId;

  @JsonKey(name: 'group')
  final UserGroup group;

  @JsonKey(name: 'isRead')
  final bool isRead;

  @JsonKey(name: 'reads')
  final Iterable<String> reads;

  const MessagingMessage({
    required this.id,
    required this.createdAt,
    required this.userId,
    required this.user,
    required this.text,
    required this.fileId,
    required this.file,
    required this.recipientId,
    required this.recipient,
    required this.groupId,
    required this.group,
    required this.isRead,
    required this.reads,
  });

  factory MessagingMessage.fromJson(Map<String, dynamic> json) =>
      _$MessagingMessageFromJson(json);
  Map<String, dynamic> toJson() => _$MessagingMessageToJson(this);
}
