// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mutes.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// ignore_for_file: avoid_private_typedef_functions, non_constant_identifier_names, subtype_of_sealed_class, invalid_use_of_internal_member, unused_element, constant_identifier_names, unnecessary_raw_strings, library_private_types_in_public_api

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

String _$MutesServiceHash() => r'f9f50d1f9e4830e1d6c54a89701e3b4d18f8fce4';

/// See also [MutesService].
class MutesServiceProvider extends AsyncNotifierProviderImpl<MutesService,
    PaginationState<User<dynamic>>> {
  MutesServiceProvider(
    this.key,
  ) : super(
          () => MutesService()..key = key,
          from: mutesServiceProvider,
          name: r'mutesServiceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$MutesServiceHash,
        );

  final AccountKey key;

  @override
  bool operator ==(Object other) {
    return other is MutesServiceProvider && other.key == key;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, key.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  FutureOr<PaginationState<User<dynamic>>> runNotifierBuild(
    covariant _$MutesService notifier,
  ) {
    return notifier.build(
      key,
    );
  }
}

typedef MutesServiceRef
    = AsyncNotifierProviderRef<PaginationState<User<dynamic>>>;

/// See also [MutesService].
final mutesServiceProvider = MutesServiceFamily();

class MutesServiceFamily
    extends Family<AsyncValue<PaginationState<User<dynamic>>>> {
  MutesServiceFamily();

  MutesServiceProvider call(
    AccountKey key,
  ) {
    return MutesServiceProvider(
      key,
    );
  }

  @override
  AsyncNotifierProviderImpl<MutesService, PaginationState<User<dynamic>>>
      getProviderOverride(
    covariant MutesServiceProvider provider,
  ) {
    return call(
      provider.key,
    );
  }

  @override
  List<ProviderOrFamily>? get allTransitiveDependencies => null;

  @override
  List<ProviderOrFamily>? get dependencies => null;

  @override
  String? get name => r'mutesServiceProvider';
}

abstract class _$MutesService
    extends BuildlessAsyncNotifier<PaginationState<User<dynamic>>> {
  late final AccountKey key;

  FutureOr<PaginationState<User<dynamic>>> build(
    AccountKey key,
  );
}
