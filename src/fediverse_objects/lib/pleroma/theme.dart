import 'package:json_annotation/json_annotation.dart';
import 'package:fediverse_objects/pleroma/theme_font.dart';
import 'package:fediverse_objects/pleroma/theme_shadow.dart';
part 'theme.g.dart';

@JsonSerializable()
class PleromaTheme {
  final int themeEngineVersion;

  final Map<String, Iterable<PleromaThemeShadow>> shadows;

  final Map<String, String> colors;

  final Map<String, double> opacity;

  final Map<String, double> radii;

  final Map<String, PleromaThemeFont> fonts;

  const PleromaTheme({
    this.themeEngineVersion,
    this.shadows,
    this.colors,
    this.opacity,
    this.radii,
    this.fonts,
  });

  factory PleromaTheme.fromJson(Map<String, dynamic> json) =>
      _$PleromaThemeFromJson(json);
}
