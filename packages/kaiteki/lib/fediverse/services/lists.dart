import "dart:async";

import "package:kaiteki/di.dart";
import "package:kaiteki/model/auth/account_key.dart";
import "package:kaiteki_core/social.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "lists.g.dart";

// TODO(Craftplacer): port ListsScreen to ListsService
@Riverpod(keepAlive: true, dependencies: [adapter, account])
class ListsService extends _$ListsService {
  late ListSupport _lists;

  @override
  Future<List<PostList>> build(AccountKey key) async {
    _lists = ref.watch(accountProvider(key))!.adapter as ListSupport;
    return _lists.getLists();
  }
}
