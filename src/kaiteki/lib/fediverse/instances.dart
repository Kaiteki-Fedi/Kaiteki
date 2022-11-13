import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kaiteki/fediverse/api_type.dart';

part 'instances.g.dart';

Future<List<InstanceData>> fetchInstances() async {
  final json = await rootBundle.loadString('assets/instances.json');
  final list = jsonDecode(json) as List<dynamic>;
  return list.map((e) {
    return InstanceData.fromJson(e);
  }).toList(growable: false);
}

@JsonSerializable()
class InstanceData {
  final ApiType type;
  final String name;
  final String? shortDescription;
  final String? favicon;
  final List<String>? rules;
  final String? rulesUrl;
  final bool usesCovenant;
  final bool usesMastodonCovenant;

  const InstanceData({
    required this.type,
    required this.name,
    this.shortDescription,
    this.favicon,
    this.rules,
    this.rulesUrl,
    this.usesCovenant = false,
    this.usesMastodonCovenant = false,
  });

  factory InstanceData.fromJson(Map<String, dynamic> json) =>
      _$InstanceDataFromJson(json);

  Map<String, dynamic> toJson() => _$InstanceDataToJson(this);
}
