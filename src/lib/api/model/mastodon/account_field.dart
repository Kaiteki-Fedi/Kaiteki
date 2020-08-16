class AccountField {
	String name;
	String value;

	AccountField.fromJson(Map<String, dynamic> json) {
		name = json["name"];
		value = json["value"];
	}
}
