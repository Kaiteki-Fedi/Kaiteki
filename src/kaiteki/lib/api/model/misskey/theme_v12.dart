import 'package:json_annotation/json_annotation.dart';
import 'package:kaiteki/api/model/misskey/theme.dart';
part 'theme_v12.g.dart';

@JsonSerializable(createToJson: false)
class MisskeyThemeV12 extends MisskeyTheme {
  @JsonKey(name: "props")
  final Map<String, String> properties;

  MisskeyThemeV12({
    String author,
    String base,
    String description,
    String id,
    String name,
    this.properties,
  }) : super(
          author: author,
          base: base,
          description: description,
          id: id,
          name: name,
        );
}
