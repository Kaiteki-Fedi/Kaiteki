import 'package:fediverse_objects/src/mastodon/account.dart';
import 'package:fediverse_objects/src/mastodon/status.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification.g.dart';

/// Represents a notification of an event relevant to the user.
@JsonSerializable()
class Notification {
  /// The account that performed the action that generated the notification.
  final Account account;

  /// The timestamp of the notification.
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  /// The id of the notification in the database.
  final String id;

  final Notification? pleroma;

  /// Status that was the object of the notification, e.g. in mentions, reblogs, favourites, or polls.
  final Status? status;

  /// The type of event that resulted in the notification.
  ///
  /// - `follow` = Someone followed you
  /// - `follow_request` = Someone requested to follow you
  /// - `mention` = Someone mentioned you in their status
  /// - `reblog` = Someone boosted one of your statuses
  /// - `favourite` = Someone favourited one of your statuses
  /// - `poll` = A poll you have voted in or created has ended
  /// - `status` = Someone you enabled notifications for has posted a status
  /// - `move` = Someone moved their account
  /// - `pleroma:emoji_reaction` = Someone reacted with emoji to your status
  /// - `pleroma:chat_mention` = Someone mentioned you in a chat message
  /// - `pleroma:report` = Someone was reported
  final String type;

  const Notification({
    required this.account,
    required this.createdAt,
    required this.id,
    required this.type,
    this.pleroma,
    this.status,
  });

  factory Notification.fromJson(Map<String, dynamic> json) =>
      _$NotificationFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationToJson(this);
}
