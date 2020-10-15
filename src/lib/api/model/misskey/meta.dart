import 'package:json_annotation/json_annotation.dart';
import 'package:kaiteki/api/model/misskey/emoji.dart';
part 'meta.g.dart';

@JsonSerializable(createToJson: false)
class MisskeyMeta {
  final String maintainerName;

  final String maintainerEmail;

  final String version;

  final String name;

  final String uri;

  final String description;

  final Iterable<String> langs;

  final String tosUrl;

  final String repositoryUrl;

  final String feedbackUrl;

  final bool secure;

  final String reportForm;

  final bool disableRegistration;

  final bool disableLocalTimeline;

  final bool disableGlobalTimeline;

  final int driveCapacityPerLocalUserMb;

  final int driveCapacityPerRemoteUserMb;

  final bool cacheRemoteFiles;

  final bool proxyRemoteFiles;

  final bool enableHcaptcha;

  final String hcaptchaSiteKey;

  final bool enableRecaptcha;

  final String recaptchaSiteKey;

  final String swPublickey;

  final String mascotImageUrl;

  final String bannerUrl;

  final String errorImageUrl;

  final String iconUrl;

  final int maxNoteTextLength;

  final Iterable<MisskeyEmoji> emojis;

  final bool requireSetup;

  final bool enableEmail;

  final bool enableTwitterIntegration;

  final bool enableGithubIntegration;

  final bool enableDiscordIntegration;

  final bool enableServiceWorker;

  const MisskeyMeta({
    this.maintainerName,
    this.maintainerEmail,
    this.version,
    this.name,
    this.uri,
    this.description,
    this.langs,
    this.tosUrl,
    this.repositoryUrl,
    this.feedbackUrl,
    this.secure,
    this.reportForm,
    this.disableRegistration,
    this.disableLocalTimeline,
    this.disableGlobalTimeline,
    this.driveCapacityPerLocalUserMb,
    this.driveCapacityPerRemoteUserMb,
    this.cacheRemoteFiles,
    this.proxyRemoteFiles,
    this.enableHcaptcha,
    this.hcaptchaSiteKey,
    this.enableRecaptcha,
    this.recaptchaSiteKey,
    this.swPublickey,
    this.mascotImageUrl,
    this.bannerUrl,
    this.errorImageUrl,
    this.iconUrl,
    this.maxNoteTextLength,
    this.emojis,
    this.requireSetup,
    this.enableEmail,
    this.enableTwitterIntegration,
    this.enableGithubIntegration,
    this.enableDiscordIntegration,
    this.enableServiceWorker,
  });

  factory MisskeyMeta.fromJson(Map<String, dynamic> json) => _$MisskeyMetaFromJson(json);
}