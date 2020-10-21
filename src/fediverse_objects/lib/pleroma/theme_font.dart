import 'package:json_annotation/json_annotation.dart';
part 'theme_font.g.dart';

@JsonSerializable()
class PleromaThemeFont {
  final String family;

  const PleromaThemeFont({
    this.family,
  });

  factory PleromaThemeFont.fromJson(Map<String, dynamic> json) =>
      _$PleromaThemeFontFromJson(json);
}
