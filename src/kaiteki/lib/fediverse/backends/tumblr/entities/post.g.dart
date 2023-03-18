// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post(
      blog: Blog.fromJson(json['blog'] as Map<String, dynamic>),
      blogName: json['blog_name'] as String,
      body: json['body'] as String?,
      bookmarklet: json['bookmarklet'] as bool?,
      canLike: json['can_like'] as bool,
      canReblog: json['can_reblog'] as bool,
      date: json['date'] as String,
      format: $enumDecode(_$PostFormatEnumMap, json['format']),
      id: json['id_string'] as String,
      isBlazed: json['is_blazed'] as bool,
      isBlazePending: json['is_blaze_pending'] as bool,
      isBlocksPostFormat: json['is_blocks_post_format'] as bool,
      liked: json['liked'] as bool?,
      noteCount: json['note_count'] as int,
      postUrl: Uri.parse(json['post_url'] as String),
      reblogKey: json['reblog_key'] as String,
      shortUrl: Uri.parse(json['short_url'] as String),
      slug: json['slug'] as String,
      sourceTitle: json['source_title'] as String?,
      sourceUrl: json['source_url'] == null
          ? null
          : Uri.parse(json['source_url'] as String),
      state: $enumDecode(_$PostStateEnumMap, json['state']),
      summary: json['summary'] as String,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      timestamp: json['timestamp'] as int,
      title: json['title'] as String?,
      totalPosts: json['total_posts'] as int?,
      type: json['type'] as String,
    );

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'id_string': instance.id,
      'blog': instance.blog,
      'can_like': instance.canLike,
      'can_reblog': instance.canReblog,
      'is_blazed': instance.isBlazed,
      'is_blaze_pending': instance.isBlazePending,
      'is_blocks_post_format': instance.isBlocksPostFormat,
      'bookmarklet': instance.bookmarklet,
      'liked': instance.liked,
      'note_count': instance.noteCount,
      'timestamp': instance.timestamp,
      'total_posts': instance.totalPosts,
      'tags': instance.tags,
      'format': _$PostFormatEnumMap[instance.format]!,
      'state': _$PostStateEnumMap[instance.state]!,
      'blog_name': instance.blogName,
      'date': instance.date,
      'reblog_key': instance.reblogKey,
      'slug': instance.slug,
      'summary': instance.summary,
      'title': instance.title,
      'type': instance.type,
      'body': instance.body,
      'source_title': instance.sourceTitle,
      'post_url': instance.postUrl.toString(),
      'short_url': instance.shortUrl.toString(),
      'source_url': instance.sourceUrl?.toString(),
    };

const _$PostFormatEnumMap = {
  PostFormat.html: 'html',
  PostFormat.markdown: 'markdown',
};

const _$PostStateEnumMap = {
  PostState.published: 'published',
  PostState.queued: 'queued',
  PostState.draft: 'draft',
  PostState.private: 'private',
};
