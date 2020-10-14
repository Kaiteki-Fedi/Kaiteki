import 'package:json_annotation/json_annotation.dart';
part 'card.g.dart';

@JsonSerializable()
class PleromaCard {
  final Map<String, String> opengraph;

  const PleromaCard(
    this.opengraph,
  );

  factory PleromaCard.fromJson(Map<String, dynamic> json) => _$PleromaCardFromJson(json);
}