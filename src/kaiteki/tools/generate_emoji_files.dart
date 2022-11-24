// ignore_for_file: cascade_invocations, avoid_print

import 'dart:io';

import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:tuple/tuple.dart';

final emojiListUri = Uri.parse(
  "https://unicode.org/Public/emoji/15.0/emoji-test.txt",
);

const commentPrefix = "# ";
const groupPrefix = "group: ";

final components = [
  "200D",
  "FE0F",
  "1F3FB",
  "1F3FC",
  "1F3FD",
  "1F3FE",
  "1F3FF",
  "1F9B0",
  "1F9B1",
  "1F9B3",
  "1F9B2",
].map(parseCodePoints).toSet();

typedef EmojiCompound = Tuple2<String, List<String>>;

void main(List<String> arguments) async {
  final lines = (await fetchEmojiList())
      .split("\n") // Split text file into lines
      .where((l) => l.isNotEmpty); // Exclude empty lines

  final groups = <String, List<EmojiCompound>>{};
  String? currentGroup;

  for (final line in lines) {
    if (line.trim().isEmpty) continue;

    if (line.startsWith(commentPrefix)) {
      final comment = line.split(commentPrefix).last;
      if (!comment.startsWith(groupPrefix)) continue;

      final group = comment.split(groupPrefix).lastOrNull;
      if (group != null) {
        print("Processing group: $group");
        currentGroup = group;
      }

      continue;
    }

    final parts = line.split("#").first.split(";").map((p) => p.trim());
    if (parts.length != 2) continue;

    // if (parts.elementAt(1) == "component") {
    //   final charCodes = parts.elementAt(0);
    //   components.add(parseCodePoints(charCodes));
    //   continue;
    // }

    if (parts.elementAt(1) != "fully-qualified") continue;

    assert(currentGroup == null);

    final compounds = groups[currentGroup!] ??= [];

    final charCodes = parts.elementAt(0);
    final emoji = parseCodePoints(charCodes);
    final withoutComponents = removeComponents(emoji);

    var compound = compounds.firstWhereOrNull(
      (c) => c.item1 == withoutComponents,
    );
    // We have an emoji that similar to the ones parsed before
    if (compound != null) {
      compound.item2.add(emoji);
      print("Found similar emoji");
    } else {
      compound = EmojiCompound(emoji, []);
      compounds.add(compound);
    }
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

String removeComponents(String input) {
  var inputCodeUnits = input.codeUnits.toSet();

  for (final component in components) {
    final set = component.codeUnits.toSet();
    inputCodeUnits = inputCodeUnits.difference(set);
  }

  return String.fromCharCodes(inputCodeUnits);
}

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

  buffer.writeln('// GENERATED CODE - DO NOT MODIFY BY HAND');
  buffer.writeln();
  buffer.writeln(
    "import 'package:kaiteki/fediverse/model/emoji/category.dart';",
  );
  buffer.writeln("import 'package:kaiteki/fediverse/model/emoji/emoji.dart';");
  buffer.writeln();
  buffer.writeln('final $fieldName = <EmojiCategoryItem<UnicodeEmoji>>[');
  for (final compound in emojis) {
    final baseEmoji = compound.item1;
    final variants = compound.item2;

    buffer.writeln('  const EmojiCategoryItem(');
    buffer.write('    const UnicodeEmoji("$baseEmoji"),');

    if (variants.isNotEmpty) {
      buffer.writeln(' [');
      for (final emoji in variants) {
        buffer.writeln('      const UnicodeEmoji("$emoji"),');
      }
      buffer.writeln('    ],');
    } else {
      buffer.writeln();
    }

    buffer.writeln('  ),');
  }
  buffer.writeln('];');

  return buffer.toString();
}

Future<String> fetchEmojiList() async {
  final response = await http.get(emojiListUri);

  if (response.statusCode != 200) {
    throw Exception("Server responded with ${response.statusCode}");
  }

  return response.body;
}
