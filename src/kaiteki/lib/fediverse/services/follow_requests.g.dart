// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'follow_requests.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$followRequestsServiceHash() =>
    r'73f300f17bcdb992b301b457f4ffd08c97437f6b';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$FollowRequestsService
    extends BuildlessAsyncNotifier<PaginationState<User>> {
  late final AccountKey key;

  FutureOr<PaginationState<User>> build(
    AccountKey key,
  );
}

/// See also [FollowRequestsService].
@ProviderFor(FollowRequestsService)
const followRequestsServiceProvider = FollowRequestsServiceFamily();

/// See also [FollowRequestsService].
class FollowRequestsServiceFamily
    extends Family<AsyncValue<PaginationState<User>>> {
  /// See also [FollowRequestsService].
  const FollowRequestsServiceFamily();

  /// See also [FollowRequestsService].
  FollowRequestsServiceProvider call(
    AccountKey key,
  ) {
    return FollowRequestsServiceProvider(
      key,
    );
  }

  @override
  FollowRequestsServiceProvider getProviderOverride(
    covariant FollowRequestsServiceProvider provider,
  ) {
    return call(
      provider.key,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'followRequestsServiceProvider';
}

/// See also [FollowRequestsService].
class FollowRequestsServiceProvider extends AsyncNotifierProviderImpl<
    FollowRequestsService, PaginationState<User>> {
  /// See also [FollowRequestsService].
  FollowRequestsServiceProvider(
    AccountKey key,
  ) : this._internal(
          () => FollowRequestsService()..key = key,
          from: followRequestsServiceProvider,
          name: r'followRequestsServiceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$followRequestsServiceHash,
          dependencies: FollowRequestsServiceFamily._dependencies,
          allTransitiveDependencies:
              FollowRequestsServiceFamily._allTransitiveDependencies,
          key: key,
        );

  FollowRequestsServiceProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.key,
  }) : super.internal();

  final AccountKey key;

  @override
  FutureOr<PaginationState<User>> runNotifierBuild(
    covariant FollowRequestsService notifier,
  ) {
    return notifier.build(
      key,
    );
  }

  @override
  Override overrideWith(FollowRequestsService Function() create) {
    return ProviderOverride(
      origin: this,
      override: FollowRequestsServiceProvider._internal(
        () => create()..key = key,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        key: key,
      ),
    );
  }

  @override
  AsyncNotifierProviderElement<FollowRequestsService, PaginationState<User>>
      createElement() {
    return _FollowRequestsServiceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FollowRequestsServiceProvider && other.key == key;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, key.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FollowRequestsServiceRef
    on AsyncNotifierProviderRef<PaginationState<User>> {
  /// The parameter `key` of this provider.
  AccountKey get key;
}

class _FollowRequestsServiceProviderElement
    extends AsyncNotifierProviderElement<FollowRequestsService,
        PaginationState<User>> with FollowRequestsServiceRef {
  _FollowRequestsServiceProviderElement(super.provider);

  @override
  AccountKey get key => (origin as FollowRequestsServiceProvider).key;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
