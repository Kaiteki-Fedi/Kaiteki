import 'package:kaiteki/api/adapters/misskey/adapter.dart';
import 'package:kaiteki/api/api_type.dart';
import 'package:kaiteki/api/definitions/definitions.dart';
import 'package:kaiteki/app_colors.dart';

class MisskeyApiDefinition extends ApiDefinition<MisskeyAdapter> {
  @override
  createAdapter() => MisskeyAdapter();

  @override
  String get name => 'Misskey';

  @override
  ApiType get type => ApiType.Misskey;

  @override
  ApiTheme get theme {
    return ApiTheme(
      backgroundColor: AppColors.misskeySecondary,
      primaryColor: AppColors.misskeyPrimary,
      iconAssetLocation: 'assets/icons/misskey.png',
    );
  }
}
