import 'package:fediverse_objects/pleroma.dart' as p;
import 'package:json_annotation/json_annotation.dart';

part 'card.g.dart';

@JsonSerializable()
class Card {
  final String description;

  final String? image;

  final p.Card pleroma;

  @JsonKey(name: 'provider_name')
  final String providerName;

  @JsonKey(name: 'provider_url')
  final String providerUrl;

  final String title;

  final String type;

  final String url;

  const Card(
    this.description,
    this.image,
    this.pleroma,
    this.providerName,
    this.providerUrl,
    this.title,
    this.type,
    this.url,
  );

  factory Card.fromJson(Map<String, dynamic> json) => _$CardFromJson(json);

  Map<String, dynamic> toJson() => _$CardToJson(this);
}
