import 'dart:convert';
import 'dart:convert' as convert show json;
import 'dart:io';

import 'package:build/build.dart';
import 'package:kaiteki_unicode_generator/src/entities/group.dart';

const _kOutputPath = 'lib/generated/unicode_emoji.g.dart';

class EmojiBuilder implements Builder {
  final Uri emojiListUrl;

  const EmojiBuilder({required this.emojiListUrl});

  @override
  final buildExtensions = const {
    r'$package$': [_kOutputPath]
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    final groups = await _fetchEmojiGroups(emojiListUrl);

    final outputBuffer =
        StringBuffer("// GENERATED CODE - DO NOT MODIFY BY HAND\n")
          ..writeln()
          ..writeln("import 'package:kaiteki_core/model.dart';")
          ..writeln();

    for (final group in groups) {
      _writeEmojiCategory(outputBuffer, group);
      outputBuffer.writeln();
    }

    final assetId = AssetId(buildStep.inputId.package, _kOutputPath);
    await buildStep.writeAsString(assetId, outputBuffer.toString());
  }

  static Future<Iterable<EmojiGroup>> _fetchEmojiGroups(Uri url) async {
    var client = HttpClient();
    final request = await client.getUrl(url);
    request.headers.contentType =
        ContentType('application', 'json', charset: 'utf-8');
    final response = await request.close();
    final list = await response
        .transform(utf8.decoder)
        .transform(convert.json.decoder)
        .first;

    if (list is! List) {
      throw FormatException("Deserialized JSON is not a list");
    }

    return list.map((e) => EmojiGroup.fromJson(e)).toList();
  }

  static String _getFieldName(String groupName) {
    String capitalize(String input) {
      final buffer = StringBuffer()
        ..write(input[0].toUpperCase())
        ..write(input.substring(1));
      return buffer.toString();
    }

    final split = groupName.split(" and ");

    return [
      for (var i = 0; i < split.length; i++)
        i == 0 ? split[i].toLowerCase() : capitalize(split[i]),
    ].join();
  }

  static void _writeEmojiCategory(StringBuffer outputBuffer, EmojiGroup group) {
    const kIndent = "  ";

    outputBuffer.writeln(
      "final ${_getFieldName(group.group)} = <EmojiCategoryItem<UnicodeEmoji>>[",
    );

    for (final compound in group.emoji) {
      final baseEmoji = String.fromCharCodes(compound.base);
      final alternates =
          compound.alternates.map((e) => String.fromCharCodes(e));
      final shortCodes = compound.shortcodes;

      final stringifiedShortCodes = shortCodes.map((e) => '"$e"').join(", ");

      outputBuffer.writeln("  const EmojiCategoryItem(");

      outputBuffer
        ..write(kIndent * 2)
        ..write('    ')
        ..write('const UnicodeEmoji("')
        ..write(baseEmoji)
        ..write('", const [')
        ..write(stringifiedShortCodes)
        ..write(']),');

      if (alternates.isNotEmpty) {
        outputBuffer.writeln(" [");

        for (final emoji in alternates) {
          outputBuffer
            ..write(kIndent * 3)
            ..write('const UnicodeEmoji("')
            ..write(emoji)
            ..write('", const [')
            ..write(stringifiedShortCodes)
            ..write(']),');
        }

        outputBuffer
          ..write(kIndent * 2)
          ..write("],");
      }

      outputBuffer.writeln();
      outputBuffer.writeln("  ),");
    }

    outputBuffer.writeln("];");
  }
}
