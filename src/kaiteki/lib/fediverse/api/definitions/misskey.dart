import 'package:kaiteki/app_colors.dart';
import 'package:kaiteki/fediverse/api/adapters/misskey/adapter.dart';
import 'package:kaiteki/fediverse/api/api_type.dart';
import 'package:kaiteki/fediverse/api/definitions/definitions.dart';

class MisskeyApiDefinition extends ApiDefinition<MisskeyAdapter> {
  @override
  MisskeyAdapter createAdapter() => MisskeyAdapter();

  @override
  String get name => 'Misskey';

  @override
  ApiType get type => ApiType.misskey;

  @override
  ApiTheme get theme {
    return const ApiTheme(
      backgroundColor: misskeySecondary,
      primaryColor: misskeyPrimary,
      iconAssetLocation: 'assets/icons/misskey.png',
    );
  }
}
