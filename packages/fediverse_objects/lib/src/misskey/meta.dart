import 'package:json_annotation/json_annotation.dart';

import 'emoji.dart';
import 'ad.dart';

part 'meta.g.dart';

@JsonSerializable()
class Meta {
  final String? maintainerName;

  final String? maintainerEmail;

  final String version;

  final String name;

  final String uri;

  final String? description;

  final List<String> langs;

  final String? tosUrl;

  final String? repositoryUrl;

  final String? feedbackUrl;

  final String? defaultDarkTheme;

  final String? defaultLightTheme;

  final bool disableRegistration;

  final bool? disableLocalTimeline;

  final bool? disableGlobalTimeline;

  final bool? disableRecommendedTimeline;

  final int? driveCapacityPerLocalUserMb;

  final int? driveCapacityPerRemoteUserMb;

  final bool? cacheRemoteFiles;

  final bool emailRequiredForSignup;

  final bool enableHcaptcha;

  final String? hcaptchaSiteKey;

  final bool enableRecaptcha;

  final String? recaptchaSiteKey;

  final String? swPublickey;

  final String? mascotImageUrl;

  final String? bannerUrl;

  final String? errorImageUrl;

  final String? iconUrl;

  final int maxNoteTextLength;

  final List<Emoji>? emojis;

  final List<Ad>? ads;

  final bool? requireSetup;

  final bool enableEmail;

  final bool? enableTwitterIntegration;

  final bool? enableGithubIntegration;

  final bool? enableDiscordIntegration;

  final bool? enableServiceWorker;

  final bool? translatorAvailable;

  final String? proxyAccountName;

  final Map<String, dynamic>? features;

  const Meta({
    required this.ads,
    required this.bannerUrl,
    required this.disableGlobalTimeline,
    required this.disableLocalTimeline,
    required this.disableRegistration,
    required this.driveCapacityPerLocalUserMb,
    required this.driveCapacityPerRemoteUserMb,
    required this.emailRequiredForSignup,
    required this.emojis,
    required this.enableEmail,
    required this.enableHcaptcha,
    required this.enableRecaptcha,
    required this.errorImageUrl,
    required this.langs,
    required this.maxNoteTextLength,
    required this.name,
    required this.repositoryUrl,
    required this.uri,
    required this.version,
    this.cacheRemoteFiles,
    this.defaultDarkTheme,
    this.defaultLightTheme,
    this.description,
    this.disableRecommendedTimeline,
    this.enableDiscordIntegration,
    this.enableGithubIntegration,
    this.enableServiceWorker,
    this.enableTwitterIntegration,
    this.features,
    this.feedbackUrl,
    this.hcaptchaSiteKey,
    this.iconUrl,
    this.maintainerEmail,
    this.maintainerName,
    this.mascotImageUrl,
    this.proxyAccountName,
    this.recaptchaSiteKey,
    this.requireSetup,
    this.swPublickey,
    this.tosUrl,
    this.translatorAvailable,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);
  Map<String, dynamic> toJson() => _$MetaToJson(this);
}
