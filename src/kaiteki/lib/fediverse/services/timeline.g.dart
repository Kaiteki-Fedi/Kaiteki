// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$timelineServiceHash() => r'b5fc76f1452c1ad405ac5169d6343a820e5f8fb8';

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

abstract class _$TimelineService extends BuildlessAsyncNotifier<
    ({bool hasReachedEnd, Iterable<Post<dynamic>> posts})> {
  late final TimelineSource source;

  FutureOr<({bool hasReachedEnd, Iterable<Post<dynamic>> posts})> build(
    TimelineSource source,
  );
}

/// See also [TimelineService].
@ProviderFor(TimelineService)
const timelineServiceProvider = TimelineServiceFamily();

/// See also [TimelineService].
class TimelineServiceFamily extends Family<
    AsyncValue<({bool hasReachedEnd, Iterable<Post<dynamic>> posts})>> {
  /// See also [TimelineService].
  const TimelineServiceFamily();

  /// See also [TimelineService].
  TimelineServiceProvider call(
    TimelineSource source,
  ) {
    return TimelineServiceProvider(
      source,
    );
  }

  @override
  TimelineServiceProvider getProviderOverride(
    covariant TimelineServiceProvider provider,
  ) {
    return call(
      provider.source,
    );
  }

  static final Iterable<ProviderOrFamily> _dependencies = <ProviderOrFamily>[
    adapterProvider
  ];

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static final Iterable<ProviderOrFamily> _allTransitiveDependencies =
      <ProviderOrFamily>{
    adapterProvider,
    ...?adapterProvider.allTransitiveDependencies
  };

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'timelineServiceProvider';
}

/// See also [TimelineService].
class TimelineServiceProvider extends AsyncNotifierProviderImpl<TimelineService,
    ({bool hasReachedEnd, Iterable<Post<dynamic>> posts})> {
  /// See also [TimelineService].
  TimelineServiceProvider(
    this.source,
  ) : super.internal(
          () => TimelineService()..source = source,
          from: timelineServiceProvider,
          name: r'timelineServiceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$timelineServiceHash,
          dependencies: TimelineServiceFamily._dependencies,
          allTransitiveDependencies:
              TimelineServiceFamily._allTransitiveDependencies,
        );

  final TimelineSource source;

  @override
  bool operator ==(Object other) {
    return other is TimelineServiceProvider && other.source == source;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, source.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  FutureOr<({bool hasReachedEnd, Iterable<Post<dynamic>> posts})>
      runNotifierBuild(
    covariant TimelineService notifier,
  ) {
    return notifier.build(
      source,
    );
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
