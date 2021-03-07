import 'package:flutter/painting.dart';
import 'package:kaiteki/fediverse/api/adapters/fediverse_adapter.dart';
import 'package:kaiteki/fediverse/api/api_type.dart';
import 'package:kaiteki/fediverse/api/definitions/mastodon.dart';
import 'package:kaiteki/fediverse/api/definitions/misskey.dart';
import 'package:kaiteki/fediverse/api/definitions/pleroma.dart';

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
    this.backgroundColor,
    this.primaryColor,
    this.iconAssetLocation,
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
