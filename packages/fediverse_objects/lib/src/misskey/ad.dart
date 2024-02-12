import 'package:json_annotation/json_annotation.dart';

part 'ad.g.dart';

@JsonSerializable()
class Ad {
  final String place;
  final String url;
  final String imageUrl;

  const Ad({
    required this.place,
    required this.url,
    required this.imageUrl,
  });

  factory Ad.fromJson(Map<String, dynamic> json) => _$AdFromJson(json);
  Map<String, dynamic> toJson() => _$AdToJson(this);
}
