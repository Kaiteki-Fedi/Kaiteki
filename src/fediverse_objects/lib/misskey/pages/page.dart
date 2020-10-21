import 'package:json_annotation/json_annotation.dart';
import 'package:fediverse_objects/misskey/user.dart';
import 'package:fediverse_objects/misskey/pages/variable.dart';
part 'page.g.dart';

@JsonSerializable(createToJson: false)
class MisskeyPage {
  final String id;

  final DateTime createdAt;

  final DateTime updatedAt;

  final String userId;

  final MisskeyUser user;

  final Iterable<Map<String, dynamic>> content;

  final Iterable<MisskeyPageVariable> variables;

  final String title;

  final String name;

  final dynamic summary;

  final bool hideTitleWhenPinned;

  final bool alignCenter;

  final String font;

  final String script;

  final String eyeCatchingImageId;

  final dynamic eyeCatchingImage;

  // final Iterable<AttachedFile> attachedFiles;

  final int likedCount;

  final bool isLiked;

  const MisskeyPage({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.userId,
    this.user,
    this.content,
    this.variables,
    this.title,
    this.name,
    this.summary,
    this.hideTitleWhenPinned,
    this.alignCenter,
    this.font,
    this.script,
    this.eyeCatchingImageId,
    this.eyeCatchingImage,
    // this.attachedFiles,
    this.likedCount,
    this.isLiked,
  });

  factory MisskeyPage.fromJson(Map<String, dynamic> json) =>
      _$MisskeyPageFromJson(json);
}
