import "package:meta/meta.dart";

@immutable
class Language {
  final String code;
  final String? englishName;

  const Language(this.code, [this.englishName]);

  @override
  String toString() => "Language($code, $englishName)";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Language &&
          runtimeType == other.runtimeType &&
          code == other.code &&
          englishName == other.englishName;

  @override
  int get hashCode => code.hashCode ^ englishName.hashCode;
}
