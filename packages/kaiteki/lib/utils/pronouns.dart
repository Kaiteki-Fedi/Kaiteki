final _caseSeparator = RegExp(r"\s?/\s?");

const kPronounsFieldKeys = [
  "pronouns",
  "pronomen",
];

List<List<String>> parsePronouns(String pronouns) {
  final list = <List<String>>[];
  final split = pronouns.toLowerCase().split(",");

  for (final pronoun in split) {
    final parts =
        pronoun.trim().split(_caseSeparator).map((e) => e.trim()).toList();

    list.add(parts);
  }

  return list;
}
