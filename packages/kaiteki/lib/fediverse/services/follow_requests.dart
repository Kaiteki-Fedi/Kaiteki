import "package:kaiteki/account_manager.dart";
import "package:kaiteki/model/auth/account_key.dart";
import "package:kaiteki/model/pagination_state.dart";
import "package:kaiteki_core/social.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "follow_requests.g.dart";

@Riverpod(keepAlive: true)
class FollowRequestsService extends _$FollowRequestsService {
  late FollowSupport _backend;
  String? _nextId;

  @override
  FutureOr<PaginationState<User>> build(AccountKey key) async {
    final account = ref
        .read(accountManagerProvider)
        .accounts
        .firstWhere((a) => a.key == key);
    _backend = account.adapter as FollowSupport;

    final pagination = await _backend.getFollowRequests();
    _nextId = pagination.next;
    return PaginationState(
      pagination.data.toList(),
      canPaginateFurther: pagination.data.isNotEmpty,
    );
  }

  Future<void> loadMore() async {
    if (state.isLoading) return;
    if (!(state.valueOrNull?.canPaginateFurther ?? false)) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final pagination = await _backend.getFollowRequests(sinceId: _nextId);
      _nextId = pagination.next;
      return PaginationState(
        [...?state.valueOrNull?.items, ...pagination.data],
        canPaginateFurther: !(_nextId == null || pagination.data.isEmpty),
      );
    });
  }

  Future<void> accept(String userId) async {
    await _backend.acceptFollowRequest(userId);

    final value = state.valueOrNull;

    if (value == null) return;

    state = AsyncValue.data(
      PaginationState(
        value.items.where((u) => u.id != userId).toList(),
        canPaginateFurther: value.canPaginateFurther,
      ),
    );
  }

  Future<void> reject(String userId) async {
    await _backend.rejectFollowRequest(userId);

    final value = state.valueOrNull;

    if (value == null) return;

    state = AsyncValue.data(
      PaginationState(
        value.items.where((u) => u.id != userId).toList(),
        canPaginateFurther: value.canPaginateFurther,
      ),
    );
  }
}
