// ignore_for_file: cascade_invocations, avoid_print

import "dart:convert";
import "dart:io";

import "package:http/http.dart" as http;
import "package:kaiteki_core/utils.dart";
import "package:path/path.dart";

final emojiListUri = Uri.parse(
  "https://raw.githubusercontent.com/googlefonts/emoji-metadata/main/emoji_15_0_ordering.json",
);

const groupNameMap = {
  "Smileys and emotions": "Smileys & Emotion",
  "People": "People & Body",
  "Animals and nature": "Animals & Nature",
  "Food and drink": "Food & Drink",
  "Activities and events": "Activities",
  "Travel and places": "Travel & Places",
};

typedef EmojiCompound = (String, List<String>, List<String>);

void main(List<String> arguments) async {
  final raw = await fetchEmojiList();
  final json = (jsonDecode(raw) as List<dynamic>).cast<JsonMap>();

  final groups = <String, List<EmojiCompound>>{};
  for (final group in json) {
    var groupName = group["group"] as String;
    groupName = groupNameMap[groupName] ?? groupName;

    final emojis = group["emoji"] as List<JsonMap>;
    final compounds = <EmojiCompound>[];

    for (final emoji in emojis) {
      final baseCodePoints = (emoji["base"] as List<dynamic>).cast<int>();
      final base = String.fromCharCodes(baseCodePoints);

      final alternates = emoji["alternates"] as List<dynamic>;
      final variants = <String>[];

      for (final a in alternates) {
        final alternateCodePoints = (a as List<dynamic>).cast<int>();
        final alternate = String.fromCharCodes(alternateCodePoints);
        variants.add(alternate);
      }

      final shortCodes = emoji["shortcodes"] as List<dynamic>;

      compounds.add((base, variants, shortCodes.cast()));
    }

    groups[groupName] = compounds;
  }

  await generateDartFiles(arguments[0], groups.entries);
}

String parseCodePoints(String input) {
  return String.fromCharCodes(
    input.split(" ").map(
      (c) {
        return int.parse(c, radix: 16);
      },
    ),
  );
}

// String removeComponents(String input) {
//   var inputCodeUnits = input.codeUnits.toSet();
//
//   for (final component in components) {
//     final set = component.codeUnits.toSet();
//     inputCodeUnits = inputCodeUnits.difference(set);
//   }
//
//   return String.fromCharCodes(inputCodeUnits);
// }

String capitalize(String input) {
  final buffer = StringBuffer();

  for (var i = 0; i < input.length; i++) {
    final char = input[i];
    if (i == 0) {
      buffer.write(char.toUpperCase());
    } else {
      buffer.write(char);
    }
  }

  return buffer.toString();
}

Future<void> generateDartFiles(
  String destinationPath,
  Iterable<MapEntry<String, List<EmojiCompound>>> entries,
) async {
  for (final group in entries) {
    var groupNameParts = group.key.toLowerCase().split(" & ");
    if (groupNameParts.length >= 2) {
      groupNameParts = [groupNameParts[0], capitalize(groupNameParts[1])];
    }

    final fieldName = groupNameParts.join();
    final fileName = group.key.toLowerCase().replaceAll(" & ", "_");

    final destination = File(joinAll([destinationPath, "$fileName.g.dart"]));
    final dartSource = generateDartFile(fieldName, group.value);
    await destination.writeAsString(dartSource, mode: FileMode.writeOnly);
  }
}

String generateDartFile(String fieldName, List<EmojiCompound> emojis) {
  final buffer = StringBuffer();

  buffer.writeln("// GENERATED CODE - DO NOT MODIFY BY HAND");
  buffer.writeln();
  buffer.writeln(
    "import 'package:kaiteki/fediverse/model/emoji/category.dart';",
  );
  buffer.writeln("import 'package:kaiteki/fediverse/model/emoji/emoji.dart';");
  buffer.writeln();
  buffer.writeln("final $fieldName = <EmojiCategoryItem<UnicodeEmoji>>[");
  for (final compound in emojis) {
    final baseEmoji = compound.$1;
    final variants = compound.$2;
    final shortCodes = compound.$3.map((e) => '"$e"').join(", ");

    buffer.writeln("  const EmojiCategoryItem(");

    buffer.write('    const UnicodeEmoji("$baseEmoji", const [$shortCodes]),');

    if (variants.isNotEmpty) {
      buffer.writeln(" [");
      for (final emoji in variants) {
        buffer.writeln(
          '      const UnicodeEmoji("$emoji", const [$shortCodes]),',
        );
      }
      buffer.writeln("    ],");
    } else {
      buffer.writeln();
    }

    buffer.writeln("  ),");
  }
  buffer.writeln("];");

  return buffer.toString();
}

Future<String> fetchEmojiList() async {
  final response = await http.get(emojiListUri);

  if (response.statusCode != 200) {
    throw Exception("Server responded with ${response.statusCode}");
  }

  return response.body;
}
