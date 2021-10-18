// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Instance _$InstanceFromJson(Map<String, dynamic> json) {
  return Instance(
    uri: json['uri'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    email: json['email'] as String,
    version: json['version'] as String,
    languages: (json['languages'] as List<dynamic>).map((e) => e as String),
    registrations: json['registrations'] as bool,
    approvalRequired: json['approval_required'] as bool,
    urls: InstanceUrls.fromJson(json['urls'] as Map<String, dynamic>),
    stats: InstanceStatistics.fromJson(json['stats'] as Map<String, dynamic>),
    shortDescription: json['shortDescription'] as String?,
    invitesEnabled: json['invites_enabled'] as bool?,
    thumbnail: json['thumbnail'] as String?,
    contactAccount: json['contact_account'] == null
        ? null
        : Account.fromJson(json['contact_account'] as Map<String, dynamic>),
    avatarUploadLimit: json['avatar_upload_limit'] as int?,
    backgroundImage: json['background_image'] as String?,
    backgroundUploadLimit: json['background_upload_limit'] as int?,
    bannerUploadLimit: json['banner_upload_limit'] as int?,
    maxTootChars: json['max_toot_chars'] as int?,
    pollLimits: json['poll_limits'],
    uploadLimit: json['upload_limit'] as int?,
  );
}

Map<String, dynamic> _$InstanceToJson(Instance instance) => <String, dynamic>{
      'avatar_upload_limit': instance.avatarUploadLimit,
      'background_image': instance.backgroundImage,
      'background_upload_limit': instance.backgroundUploadLimit,
      'banner_upload_limit': instance.bannerUploadLimit,
      'description': instance.description,
      'shortDescription': instance.shortDescription,
      'email': instance.email,
      'languages': instance.languages.toList(),
      'max_toot_chars': instance.maxTootChars,
      'poll_limits': instance.pollLimits,
      'registrations': instance.registrations,
      'thumbnail': instance.thumbnail,
      'title': instance.title,
      'upload_limit': instance.uploadLimit,
      'uri': instance.uri,
      'urls': instance.urls,
      'version': instance.version,
      'stats': instance.stats,
      'contact_account': instance.contactAccount,
      'invites_enabled': instance.invitesEnabled,
      'approval_required': instance.approvalRequired,
    };
