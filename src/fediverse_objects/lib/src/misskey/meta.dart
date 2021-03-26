import 'package:fediverse_objects/src/misskey/emoji.dart';
import 'package:json_annotation/json_annotation.dart';
part 'meta.g.dart';

@JsonSerializable()
class MisskeyMeta {
  final String? maintainerName;

  final String? maintainerEmail;

  final String version;

  final String name;

  final String uri;

  final String? description;

  final Iterable<String> langs;

  final String? tosUrl;

  final String repositoryUrl;

  final String feedbackUrl;

  final bool secure;

  final bool disableRegistration;

  final bool disableLocalTimeline;

  final bool disableGlobalTimeline;

  final int driveCapacityPerLocalUserMb;

  final int driveCapacityPerRemoteUserMb;

  final bool cacheRemoteFiles;

  final bool proxyRemoteFiles;

  final bool enableHcaptcha;

  final String? hcaptchaSiteKey;

  final bool enableRecaptcha;

  final String? recaptchaSiteKey;

  final String? swPublickey;

  final String mascotImageUrl;

  final String bannerUrl;

  final String errorImageUrl;

  final String? iconUrl;

  final int maxNoteTextLength;

  final Iterable<MisskeyEmoji> emojis;

  final bool requireSetup;

  final bool enableEmail;

  final bool enableTwitterIntegration;

  final bool enableGithubIntegration;

  final bool enableDiscordIntegration;

  final bool enableServiceWorker;

  const MisskeyMeta({
    required this.maintainerName,
    required this.maintainerEmail,
    required this.version,
    required this.name,
    required this.uri,
    required this.description,
    required this.langs,
    required this.tosUrl,
    required this.repositoryUrl,
    required this.feedbackUrl,
    required this.secure,
    required this.disableRegistration,
    required this.disableLocalTimeline,
    required this.disableGlobalTimeline,
    required this.driveCapacityPerLocalUserMb,
    required this.driveCapacityPerRemoteUserMb,
    required this.cacheRemoteFiles,
    required this.proxyRemoteFiles,
    required this.enableHcaptcha,
    required this.hcaptchaSiteKey,
    required this.enableRecaptcha,
    required this.recaptchaSiteKey,
    required this.swPublickey,
    required this.mascotImageUrl,
    required this.bannerUrl,
    required this.errorImageUrl,
    required this.iconUrl,
    required this.maxNoteTextLength,
    required this.emojis,
    required this.requireSetup,
    required this.enableEmail,
    required this.enableTwitterIntegration,
    required this.enableGithubIntegration,
    required this.enableDiscordIntegration,
    required this.enableServiceWorker,
  });

  factory MisskeyMeta.fromJson(Map<String, dynamic> json) =>
      _$MisskeyMetaFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyMetaToJson(this);
}
