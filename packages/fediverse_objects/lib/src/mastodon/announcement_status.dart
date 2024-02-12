import 'package:json_annotation/json_annotation.dart';

part 'announcement_status.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AnnouncementStatus {
  final String id;
  final Uri url;

  const AnnouncementStatus({required this.id, required this.url});

  factory AnnouncementStatus.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementStatusFromJson(json);

  Map<String, dynamic> toJson() => _$AnnouncementStatusToJson(this);
}
