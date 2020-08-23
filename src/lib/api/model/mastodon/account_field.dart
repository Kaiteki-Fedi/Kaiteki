class MastodonAccountField {
	String name;
	String value;

	MastodonAccountField.fromJson(Map<String, dynamic> json) {
		name = json["name"];
		value = json["value"];
	}
}
