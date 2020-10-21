// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_shadow.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PleromaThemeShadow _$PleromaThemeShadowFromJson(Map<String, dynamic> json) {
  return PleromaThemeShadow(
    x: json['x'] as int,
    y: json['y'] as int,
    blur: json['blur'] as int,
    spread: json['spread'] as int,
    color: json['color'] as String,
    alpha: (json['alpha'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$PleromaThemeShadowToJson(PleromaThemeShadow instance) =>
    <String, dynamic>{
      'x': instance.x,
      'y': instance.y,
      'blur': instance.blur,
      'spread': instance.spread,
      'color': instance.color,
      'alpha': instance.alpha,
    };
