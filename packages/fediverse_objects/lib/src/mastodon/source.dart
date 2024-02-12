import 'field.dart';
import '../pleroma/source.dart';
import 'package:json_annotation/json_annotation.dart';

part 'source.g.dart';

/// Represents display or publishing preferences of user's own account.
///
/// Returned as an additional entity when verifying and updated credentials, as
/// an attribute of Account.
@JsonSerializable(fieldRename: FieldRename.snake)
class Source {
  /// Profile bio.
  final String note;

  /// Profile bio.
  final List<Field> fields;

  final String? privacy;

  /// Whether new statuses should be marked sensitive by default.
  final bool? sensitive;

  /// The default posting language for new statuses.
  final String? language;

  /// The number of pending follow requests.
  final int? followRequestsCount;

  final PleromaSource? pleroma;

  const Source({
    required this.note,
    required this.fields,
    this.privacy,
    this.sensitive,
    this.language,
    this.followRequestsCount,
    this.pleroma,
  });

  factory Source.fromJson(Map<String, dynamic> json) => _$SourceFromJson(json);

  Map<String, dynamic> toJson() => _$SourceToJson(this);
}
