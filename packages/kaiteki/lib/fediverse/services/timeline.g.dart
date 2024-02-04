// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$timelineServiceHash() => r'470a3bff3a013cfd8ca5f35639792ec0e0d04158';

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

abstract class _$TimelineService
    extends BuildlessAsyncNotifier<PaginationState<Post>> {
  late final AccountKey key;
  late final TimelineSource source;

  FutureOr<PaginationState<Post>> build(
    AccountKey key,
    TimelineSource source,
  );
}

/// See also [TimelineService].
@ProviderFor(TimelineService)
const timelineServiceProvider = TimelineServiceFamily();

/// See also [TimelineService].
class TimelineServiceFamily extends Family<AsyncValue<PaginationState<Post>>> {
  /// See also [TimelineService].
  const TimelineServiceFamily();

  /// See also [TimelineService].
  TimelineServiceProvider call(
    AccountKey key,
    TimelineSource source,
  ) {
    return TimelineServiceProvider(
      key,
      source,
    );
  }

  @override
  TimelineServiceProvider getProviderOverride(
    covariant TimelineServiceProvider provider,
  ) {
    return call(
      provider.key,
      provider.source,
    );
  }

  static final Iterable<ProviderOrFamily> _dependencies = <ProviderOrFamily>[
    adapterProvider,
    accountProvider
  ];

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static final Iterable<ProviderOrFamily> _allTransitiveDependencies =
      <ProviderOrFamily>{
    adapterProvider,
    ...?adapterProvider.allTransitiveDependencies,
    accountProvider,
    ...?accountProvider.allTransitiveDependencies
  };

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'timelineServiceProvider';
}

/// See also [TimelineService].
class TimelineServiceProvider
    extends AsyncNotifierProviderImpl<TimelineService, PaginationState<Post>> {
  /// See also [TimelineService].
  TimelineServiceProvider(
    AccountKey key,
    TimelineSource source,
  ) : this._internal(
          () => TimelineService()
            ..key = key
            ..source = source,
          from: timelineServiceProvider,
          name: r'timelineServiceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$timelineServiceHash,
          dependencies: TimelineServiceFamily._dependencies,
          allTransitiveDependencies:
              TimelineServiceFamily._allTransitiveDependencies,
          key: key,
          source: source,
        );

  TimelineServiceProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.key,
    required this.source,
  }) : super.internal();

  final AccountKey key;
  final TimelineSource source;

  @override
  FutureOr<PaginationState<Post>> runNotifierBuild(
    covariant TimelineService notifier,
  ) {
    return notifier.build(
      key,
      source,
    );
  }

  @override
  Override overrideWith(TimelineService Function() create) {
    return ProviderOverride(
      origin: this,
      override: TimelineServiceProvider._internal(
        () => create()
          ..key = key
          ..source = source,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        key: key,
        source: source,
      ),
    );
  }

  @override
  AsyncNotifierProviderElement<TimelineService, PaginationState<Post>>
      createElement() {
    return _TimelineServiceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TimelineServiceProvider &&
        other.key == key &&
        other.source == source;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, key.hashCode);
    hash = _SystemHash.combine(hash, source.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TimelineServiceRef on AsyncNotifierProviderRef<PaginationState<Post>> {
  /// The parameter `key` of this provider.
  AccountKey get key;

  /// The parameter `source` of this provider.
  TimelineSource get source;
}

class _TimelineServiceProviderElement
    extends AsyncNotifierProviderElement<TimelineService, PaginationState<Post>>
    with TimelineServiceRef {
  _TimelineServiceProviderElement(super.provider);

  @override
  AccountKey get key => (origin as TimelineServiceProvider).key;
  @override
  TimelineSource get source => (origin as TimelineServiceProvider).source;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
