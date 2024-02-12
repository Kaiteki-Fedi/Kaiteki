import 'package:json_annotation/json_annotation.dart';

part 'announcement.g.dart';

@JsonSerializable()
class Announcement {
  final String id;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String text;
  final String title;
  final Uri? imageUrl;
  final bool? isRead;

  // from firefish api docs
  final bool? showPopup;

  // from firefish api docs
  final bool? isGoodNews;

  // from sharkey api resp
  final bool? needsConfirmationToRead;

  // from sharkey api resp
  final String? icon;

  // from sharkey api resp
  final String? display;

  const Announcement({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.text,
    required this.title,
    required this.imageUrl,
    required this.isRead,
    this.showPopup,
    this.isGoodNews,
    this.needsConfirmationToRead,
    this.icon,
    this.display,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementFromJson(json);

  Map<String, dynamic> toJson() => _$AnnouncementToJson(this);
}
