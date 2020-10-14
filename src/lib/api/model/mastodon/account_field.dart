import 'package:json_annotation/json_annotation.dart';
part 'account_field.g.dart';

@JsonSerializable()
class MastodonAccountField {
	final String name;

	final String value;

	const MastodonAccountField(
		this.name,
		this.value,
	);

	factory MastodonAccountField.fromJson(Map<String, dynamic> json) => _$MastodonAccountFieldFromJson(json);
}