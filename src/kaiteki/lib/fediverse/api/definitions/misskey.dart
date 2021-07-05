import 'package:kaiteki/fediverse/api/adapters/misskey/adapter.dart';
import 'package:kaiteki/fediverse/api/api_type.dart';
import 'package:kaiteki/fediverse/api/definitions/definitions.dart';
import 'package:kaiteki/app_colors.dart';

class MisskeyApiDefinition extends ApiDefinition<MisskeyAdapter> {
  @override
  createAdapter() => MisskeyAdapter();

  @override
  String get name => 'Misskey';

  @override
  ApiType get type => ApiType.misskey;

  @override
  ApiTheme get theme {
    return ApiTheme(
      backgroundColor: AppColors.misskeySecondary,
      primaryColor: AppColors.misskeyPrimary,
      iconAssetLocation: 'assets/icons/misskey.png',
    );
  }
}
