import 'package:json_annotation/json_annotation.dart';
import 'package:fediverse_objects/pleroma/card.dart';
part 'card.g.dart';

@JsonSerializable(createToJson: false)
class MastodonCard {
  final String description;

  final String image;

  final PleromaCard pleroma;

  @JsonKey(name: "provider_name")
  final String providerName;

  @JsonKey(name: "provider_url")
  final String providerUrl;

  final String title;

  final String type;

  final String url;

  const MastodonCard(
    this.description,
    this.image,
    this.pleroma,
    this.providerName,
    this.providerUrl,
    this.title,
    this.type,
    this.url,
  );

  factory MastodonCard.fromJson(Map<String, dynamic> json) =>
      _$MastodonCardFromJson(json);
}
