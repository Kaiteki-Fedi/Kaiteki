import 'package:json_annotation/json_annotation.dart';
import 'package:fediverse_objects/misskey/theme.dart';
part 'theme_v11.g.dart';

@JsonSerializable(createToJson: false)
class MisskeyThemeV11 extends MisskeyTheme {
  @JsonKey(name: "vars")
  final Map<String, String> variables;

  MisskeyThemeV11({
    String author,
    String base,
    String description,
    String id,
    String name,
    this.variables,
  }) : super(
          author: author,
          base: base,
          description: description,
          id: id,
          name: name,
        );
}
