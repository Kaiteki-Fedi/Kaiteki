import "package:flutter/material.dart";

class PostWidgetTheme extends StatelessWidget {
  final PostWidgetThemeData data;
  final Widget child;

  const PostWidgetTheme({super.key, required this.data, required this.child});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final extensions = themeData.extensions.entries.map(
      (kv) => kv.key == PostWidgetThemeData
          ? (kv.value as PostWidgetThemeData).merge(data)
          : kv.value,
    );
    return Theme(
      data: themeData.copyWith(extensions: extensions),
      child: child,
    );
  }

  static PostWidgetThemeData? of(BuildContext context) {
    return Theme.of(context).extension<PostWidgetThemeData>();
  }
}

class PostWidgetThemeData extends ThemeExtension<PostWidgetThemeData> {
  final bool? showParentPost;
  final bool? showActions;
  final bool? showReplyee;
  final bool? showAvatar;
  final bool? showTime;
  final bool? showVisibility;
  final bool? showLanguage;
  final bool? useCards;

  const PostWidgetThemeData({
    this.showParentPost,
    this.showActions,
    this.showReplyee,
    this.showAvatar,
    this.showTime,
    this.showVisibility,
    this.showLanguage,
    this.useCards,
  });

  @override
  PostWidgetThemeData copyWith({
    bool? showParentPost,
    bool? showActions,
    bool? showReplyee,
    bool? showAvatar,
    bool? showTime,
    bool? showVisibility,
    bool? showLanguage,
    bool? useCards,
  }) {
    return PostWidgetThemeData(
      showParentPost: showParentPost ?? this.showParentPost,
      showActions: showActions ?? this.showActions,
      showReplyee: showReplyee ?? this.showReplyee,
      showAvatar: showAvatar ?? this.showAvatar,
      showTime: showTime ?? this.showTime,
      showVisibility: showVisibility ?? this.showVisibility,
      showLanguage: showLanguage ?? this.showLanguage,
      useCards: useCards ?? this.useCards,
    );
  }

  PostWidgetThemeData merge(PostWidgetThemeData other) {
    return copyWith(
      showParentPost: other.showParentPost,
      showActions: other.showActions,
      showReplyee: other.showReplyee,
      showAvatar: other.showAvatar,
      showTime: other.showTime,
      showVisibility: other.showVisibility,
      showLanguage: other.showLanguage,
      useCards: other.useCards,
    );
  }

  @override
  PostWidgetThemeData lerp(covariant PostWidgetThemeData other, double t) {
    return PostWidgetThemeData(
      showParentPost: t < 0.5 ? showParentPost : other.showParentPost,
      showActions: t < 0.5 ? showActions : other.showActions,
      showReplyee: t < 0.5 ? showReplyee : other.showReplyee,
      showAvatar: t < 0.5 ? showAvatar : other.showAvatar,
      showTime: t < 0.5 ? showTime : other.showTime,
      showVisibility: t < 0.5 ? showVisibility : other.showVisibility,
      showLanguage: t < 0.5 ? showLanguage : other.showLanguage,
      useCards: t < 0.5 ? useCards : other.useCards,
    );
  }
}
