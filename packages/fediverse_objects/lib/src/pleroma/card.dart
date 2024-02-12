import 'package:json_annotation/json_annotation.dart';

part 'card.g.dart';

@JsonSerializable()
class PleromaCard {
  final Map<String, dynamic> opengraph;

  const PleromaCard(this.opengraph);

  factory PleromaCard.fromJson(Map<String, dynamic> json) =>
      _$PleromaCardFromJson(json);

  Map<String, dynamic> toJson() => _$PleromaCardToJson(this);
}
