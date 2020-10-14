// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyMeta _$MisskeyMetaFromJson(Map<String, dynamic> json) {
  return MisskeyMeta(
    maintainerName: json['maintainerName'] as String,
    maintainerEmail: json['maintainerEmail'] as String,
    version: json['version'] as String,
    name: json['name'] as String,
    uri: json['uri'] as String,
    description: json['description'] as String,
    langs: (json['langs'] as List)?.map((e) => e as String),
    tosUrl: json['tosUrl'] as String,
    repositoryUrl: json['repositoryUrl'] as String,
    feedbackUrl: json['feedbackUrl'] as String,
    secure: json['secure'] as bool,
    reportForm: json['reportForm'] as String,
    disableRegistration: json['disableRegistration'] as bool,
    disableLocalTimeline: json['disableLocalTimeline'] as bool,
    disableGlobalTimeline: json['disableGlobalTimeline'] as bool,
    driveCapacityPerLocalUserMb: json['driveCapacityPerLocalUserMb'] as int,
    driveCapacityPerRemoteUserMb: json['driveCapacityPerRemoteUserMb'] as int,
    cacheRemoteFiles: json['cacheRemoteFiles'] as bool,
    proxyRemoteFiles: json['proxyRemoteFiles'] as bool,
    enableHcaptcha: json['enableHcaptcha'] as bool,
    hcaptchaSiteKey: json['hcaptchaSiteKey'] as String,
    enableRecaptcha: json['enableRecaptcha'] as bool,
    recaptchaSiteKey: json['recaptchaSiteKey'] as String,
    swPublickey: json['swPublickey'] as String,
    mascotImageUrl: json['mascotImageUrl'] as String,
    bannerUrl: json['bannerUrl'] as String,
    errorImageUrl: json['errorImageUrl'] as String,
    iconUrl: json['iconUrl'] as String,
    maxNoteTextLength: json['maxNoteTextLength'] as int,
    emojis: (json['emojis'] as List)?.map((e) =>
        e == null ? null : MisskeyEmoji.fromJson(e as Map<String, dynamic>)),
    requireSetup: json['requireSetup'] as bool,
    enableEmail: json['enableEmail'] as bool,
    enableTwitterIntegration: json['enableTwitterIntegration'] as bool,
    enableGithubIntegration: json['enableGithubIntegration'] as bool,
    enableDiscordIntegration: json['enableDiscordIntegration'] as bool,
    enableServiceWorker: json['enableServiceWorker'] as bool,
  );
}

Map<String, dynamic> _$MisskeyMetaToJson(MisskeyMeta instance) =>
    <String, dynamic>{
      'maintainerName': instance.maintainerName,
      'maintainerEmail': instance.maintainerEmail,
      'version': instance.version,
      'name': instance.name,
      'uri': instance.uri,
      'description': instance.description,
      'langs': instance.langs?.toList(),
      'tosUrl': instance.tosUrl,
      'repositoryUrl': instance.repositoryUrl,
      'feedbackUrl': instance.feedbackUrl,
      'secure': instance.secure,
      'reportForm': instance.reportForm,
      'disableRegistration': instance.disableRegistration,
      'disableLocalTimeline': instance.disableLocalTimeline,
      'disableGlobalTimeline': instance.disableGlobalTimeline,
      'driveCapacityPerLocalUserMb': instance.driveCapacityPerLocalUserMb,
      'driveCapacityPerRemoteUserMb': instance.driveCapacityPerRemoteUserMb,
      'cacheRemoteFiles': instance.cacheRemoteFiles,
      'proxyRemoteFiles': instance.proxyRemoteFiles,
      'enableHcaptcha': instance.enableHcaptcha,
      'hcaptchaSiteKey': instance.hcaptchaSiteKey,
      'enableRecaptcha': instance.enableRecaptcha,
      'recaptchaSiteKey': instance.recaptchaSiteKey,
      'swPublickey': instance.swPublickey,
      'mascotImageUrl': instance.mascotImageUrl,
      'bannerUrl': instance.bannerUrl,
      'errorImageUrl': instance.errorImageUrl,
      'iconUrl': instance.iconUrl,
      'maxNoteTextLength': instance.maxNoteTextLength,
      'emojis': instance.emojis?.toList(),
      'requireSetup': instance.requireSetup,
      'enableEmail': instance.enableEmail,
      'enableTwitterIntegration': instance.enableTwitterIntegration,
      'enableGithubIntegration': instance.enableGithubIntegration,
      'enableDiscordIntegration': instance.enableDiscordIntegration,
      'enableServiceWorker': instance.enableServiceWorker,
    };
