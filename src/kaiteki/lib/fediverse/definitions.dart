import 'package:flutter/painting.dart';
import 'package:kaiteki/fediverse/adapter.dart';
import 'package:kaiteki/fediverse/api_type.dart';
import 'package:kaiteki/fediverse/backends/mastodon/definition.dart';
import 'package:kaiteki/fediverse/backends/misskey/definition.dart';
import 'package:kaiteki/fediverse/backends/pleroma/definition.dart';

abstract class ApiDefinition<T extends FediverseAdapter> {
  T createAdapter();

  /// The brand theme used for login procedures.
  ApiTheme get theme;

  ApiType get type;

  String get name;

  String get id => type.toId();
}

class ApiTheme {
  final Color backgroundColor;
  final Color primaryColor;
  final String iconAssetLocation;

  const ApiTheme({
    required this.backgroundColor,
    required this.primaryColor,
    required this.iconAssetLocation,
  });
}

class ApiDefinitions {
  static List<ApiDefinition> definitions = <ApiDefinition>[
    MastodonApiDefinition(),
    PleromaApiDefinition(),
    MisskeyApiDefinition(),
  ];

  static ApiDefinition byType(ApiType type) {
    return definitions.firstWhere((definition) => definition.type == type);
  }
}
