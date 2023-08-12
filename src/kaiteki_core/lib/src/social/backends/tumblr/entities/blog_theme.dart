import 'package:json_annotation/json_annotation.dart';
import 'package:kaiteki_core/utils.dart';

part 'blog_theme.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class BlogTheme {
  // final String? headerBounds;
  // final String? headerFocusHeight;
  // final String? headerFocusWidth;
  // final String? headerFullHeight;
  // final String? headerFullWidth;
  final bool? headerStretch;
  final bool? showAvatar;
  final bool? showDescription;
  final bool? showHeaderImage;
  final bool? showTitle;
  final AvatarShape? avatarShape;
  final String? backgroundColor;
  final String? backgroundTiling;
  final String? bodyFont;
  final String? headerImageScaled;
  final String? linkColor;
  final String? titleColor;
  final String? titleFont;
  final String? titleFontWeight;
  final Uri? headerImage;

  const BlogTheme({
    this.avatarShape,
    this.backgroundColor,
    this.backgroundTiling,
    this.bodyFont,
    this.headerImage,
    this.headerImageScaled,
    this.headerStretch,
    this.linkColor,
    this.showAvatar,
    this.showDescription,
    this.showHeaderImage,
    this.showTitle,
    this.titleColor,
    this.titleFont,
    this.titleFontWeight,
  });

  factory BlogTheme.fromJson(JsonMap json) => _$BlogThemeFromJson(json);
}

enum AvatarShape { circle, square }
