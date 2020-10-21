import 'package:json_annotation/json_annotation.dart';
part 'theme_shadow.g.dart';

@JsonSerializable()
class PleromaThemeShadow {
  final int x;

  final int y;

  final int blur;

  final int spread;

  final String color;

  final double alpha;

  const PleromaThemeShadow({
    this.x,
    this.y,
    this.blur,
    this.spread,
    this.color,
    this.alpha,
  });

  factory PleromaThemeShadow.fromJson(Map<String, dynamic> json) =>
      _$PleromaThemeShadowFromJson(json);
}
