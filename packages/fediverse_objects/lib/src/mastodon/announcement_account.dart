import 'package:json_annotation/json_annotation.dart';

part 'announcement_account.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AnnouncementAccount {
  final String id;
  final String username;
  final String acct;
  final Uri url;

  const AnnouncementAccount({
    required this.id,
    required this.username,
    required this.acct,
    required this.url,
  });

  factory AnnouncementAccount.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementAccountFromJson(json);

  Map<String, dynamic> toJson() => _$AnnouncementAccountToJson(this);
}
