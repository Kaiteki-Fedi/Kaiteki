import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/interfaces/custom_emoji_support.dart';
import 'package:kaiteki/fediverse/model/emoji/category.dart';
import 'package:kaiteki/model/auth/account_key.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'emoji.g.dart';

@Riverpod(keepAlive: true)
class EmojiService extends _$EmojiService {
  late CustomEmojiSupport _backend;

  @override
  FutureOr<List<EmojiCategory>> build(AccountKey key) async {
    final manager = ref.read(accountManagerProvider);
    final account = manager.accounts.firstWhere((a) => a.key == key);
    _backend = account.adapter as CustomEmojiSupport;
    return await _backend.getEmojis();
  }
}
