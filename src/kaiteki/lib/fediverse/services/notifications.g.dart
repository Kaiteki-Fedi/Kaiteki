// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$notificationServiceHash() =>
    r'b33cfa5639f5f400279558977435f3921518b47b';

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

abstract class _$NotificationService
    extends BuildlessAsyncNotifier<List<Notification>> {
  late final AccountKey key;

  FutureOr<List<Notification>> build(
    AccountKey key,
  );
}

/// See also [NotificationService].
@ProviderFor(NotificationService)
const notificationServiceProvider = NotificationServiceFamily();

/// See also [NotificationService].
class NotificationServiceFamily extends Family<AsyncValue<List<Notification>>> {
  /// See also [NotificationService].
  const NotificationServiceFamily();

  /// See also [NotificationService].
  NotificationServiceProvider call(
    AccountKey key,
  ) {
    return NotificationServiceProvider(
      key,
    );
  }

  @override
  NotificationServiceProvider getProviderOverride(
    covariant NotificationServiceProvider provider,
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
  String? get name => r'notificationServiceProvider';
}

/// See also [NotificationService].
class NotificationServiceProvider
    extends AsyncNotifierProviderImpl<NotificationService, List<Notification>> {
  /// See also [NotificationService].
  NotificationServiceProvider(
    AccountKey key,
  ) : this._internal(
          () => NotificationService()..key = key,
          from: notificationServiceProvider,
          name: r'notificationServiceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$notificationServiceHash,
          dependencies: NotificationServiceFamily._dependencies,
          allTransitiveDependencies:
              NotificationServiceFamily._allTransitiveDependencies,
          key: key,
        );

  NotificationServiceProvider._internal(
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
  FutureOr<List<Notification>> runNotifierBuild(
    covariant NotificationService notifier,
  ) {
    return notifier.build(
      key,
    );
  }

  @override
  Override overrideWith(NotificationService Function() create) {
    return ProviderOverride(
      origin: this,
      override: NotificationServiceProvider._internal(
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
  AsyncNotifierProviderElement<NotificationService, List<Notification>>
      createElement() {
    return _NotificationServiceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NotificationServiceProvider && other.key == key;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, key.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin NotificationServiceRef on AsyncNotifierProviderRef<List<Notification>> {
  /// The parameter `key` of this provider.
  AccountKey get key;
}

class _NotificationServiceProviderElement extends AsyncNotifierProviderElement<
    NotificationService, List<Notification>> with NotificationServiceRef {
  _NotificationServiceProviderElement(super.provider);

  @override
  AccountKey get key => (origin as NotificationServiceProvider).key;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
