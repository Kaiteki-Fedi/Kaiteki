// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog_theme.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlogTheme _$BlogThemeFromJson(Map<String, dynamic> json) => BlogTheme(
      avatarShape:
          $enumDecodeNullable(_$AvatarShapeEnumMap, json['avatar_shape']),
      backgroundColor: json['background_color'] as String?,
      backgroundTiling: json['background_tiling'] as String?,
      bodyFont: json['body_font'] as String?,
      headerImage: json['header_image'] == null
          ? null
          : Uri.parse(json['header_image'] as String),
      headerImageScaled: json['header_image_scaled'] as String?,
      headerStretch: json['header_stretch'] as bool?,
      linkColor: json['link_color'] as String?,
      showAvatar: json['show_avatar'] as bool?,
      showDescription: json['show_description'] as bool?,
      showHeaderImage: json['show_header_image'] as bool?,
      showTitle: json['show_title'] as bool?,
      titleColor: json['title_color'] as String?,
      titleFont: json['title_font'] as String?,
      titleFontWeight: json['title_font_weight'] as String?,
    );

Map<String, dynamic> _$BlogThemeToJson(BlogTheme instance) => <String, dynamic>{
      'header_stretch': instance.headerStretch,
      'show_avatar': instance.showAvatar,
      'show_description': instance.showDescription,
      'show_header_image': instance.showHeaderImage,
      'show_title': instance.showTitle,
      'avatar_shape': _$AvatarShapeEnumMap[instance.avatarShape],
      'background_color': instance.backgroundColor,
      'background_tiling': instance.backgroundTiling,
      'body_font': instance.bodyFont,
      'header_image_scaled': instance.headerImageScaled,
      'link_color': instance.linkColor,
      'title_color': instance.titleColor,
      'title_font': instance.titleFont,
      'title_font_weight': instance.titleFontWeight,
      'header_image': instance.headerImage?.toString(),
    };

const _$AvatarShapeEnumMap = {
  AvatarShape.circle: 'circle',
  AvatarShape.square: 'square',
};
