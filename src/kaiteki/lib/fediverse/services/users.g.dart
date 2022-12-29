// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users.dart';

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

String $UsersServiceHash() => r'631460631420ad196db95a548ee5e2272b9cc151';

/// See also [UsersService].
class UsersServiceProvider
    extends AsyncNotifierProviderImpl<UsersService, User<dynamic>> {
  UsersServiceProvider(
    this.key,
    this.id,
  ) : super(
          () => UsersService()
            ..key = key
            ..id = id,
          from: usersServiceProvider,
          name: r'usersServiceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : $UsersServiceHash,
        );

  final AccountKey key;
  final String id;

  @override
  bool operator ==(Object other) {
    return other is UsersServiceProvider && other.key == key && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, key.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  FutureOr<User<dynamic>> runNotifierBuild(
    covariant _$UsersService notifier,
  ) {
    return notifier.build(
      key,
      id,
    );
  }
}

typedef UsersServiceRef = AsyncNotifierProviderRef<User<dynamic>>;

/// See also [UsersService].
final usersServiceProvider = UsersServiceFamily();

class UsersServiceFamily extends Family<AsyncValue<User<dynamic>>> {
  UsersServiceFamily();

  UsersServiceProvider call(
    AccountKey key,
    String id,
  ) {
    return UsersServiceProvider(
      key,
      id,
    );
  }

  @override
  AsyncNotifierProviderImpl<UsersService, User<dynamic>> getProviderOverride(
    covariant UsersServiceProvider provider,
  ) {
    return call(
      provider.key,
      provider.id,
    );
  }

  @override
  List<ProviderOrFamily>? get allTransitiveDependencies => null;

  @override
  List<ProviderOrFamily>? get dependencies => null;

  @override
  String? get name => r'usersServiceProvider';
}

abstract class _$UsersService extends BuildlessAsyncNotifier<User<dynamic>> {
  late final AccountKey key;
  late final String id;

  FutureOr<User<dynamic>> build(
    AccountKey key,
    String id,
  );
}
