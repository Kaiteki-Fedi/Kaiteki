import 'package:json_annotation/json_annotation.dart';

import 'announcement_account.dart';
import 'announcement_status.dart';
import 'custom_emoji.dart';
import 'reaction.dart';
import 'tag.dart';

part 'announcement.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Announcement {
  final String id;
  final String content;
  final DateTime? startsAt;
  final DateTime? endsAt;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final bool allDay;
  final bool? read;
  final List<AnnouncementAccount> mentions;
  final List<AnnouncementStatus> statuses;
  final List<Tag> tags;
  final List<CustomEmoji> emojis;
  final List<Reaction> reactions;

  const Announcement({
    required this.id,
    required this.content,
    required this.startsAt,
    required this.endsAt,
    required this.updatedAt,
    required this.createdAt,
    required this.allDay,
    required this.read,
    required this.mentions,
    required this.statuses,
    required this.tags,
    required this.emojis,
    required this.reactions,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementFromJson(json);

  Map<String, dynamic> toJson() => _$AnnouncementToJson(this);
}
