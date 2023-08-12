// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$usersServiceHash() => r'03291de8674c3ae95ac80b3e062d7c9ab371dbd9';

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

abstract class _$UsersService extends BuildlessAsyncNotifier<User<dynamic>?> {
  late final AccountKey key;
  late final String id;

  FutureOr<User<dynamic>?> build(
    AccountKey key,
    String id,
  );
}

/// See also [UsersService].
@ProviderFor(UsersService)
const usersServiceProvider = UsersServiceFamily();

/// See also [UsersService].
class UsersServiceFamily extends Family<AsyncValue<User<dynamic>?>> {
  /// See also [UsersService].
  const UsersServiceFamily();

  /// See also [UsersService].
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
  UsersServiceProvider getProviderOverride(
    covariant UsersServiceProvider provider,
  ) {
    return call(
      provider.key,
      provider.id,
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
  String? get name => r'usersServiceProvider';
}

/// See also [UsersService].
class UsersServiceProvider
    extends AsyncNotifierProviderImpl<UsersService, User<dynamic>?> {
  /// See also [UsersService].
  UsersServiceProvider(
    this.key,
    this.id,
  ) : super.internal(
          () => UsersService()
            ..key = key
            ..id = id,
          from: usersServiceProvider,
          name: r'usersServiceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$usersServiceHash,
          dependencies: UsersServiceFamily._dependencies,
          allTransitiveDependencies:
              UsersServiceFamily._allTransitiveDependencies,
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
  FutureOr<User<dynamic>?> runNotifierBuild(
    covariant UsersService notifier,
  ) {
    return notifier.build(
      key,
      id,
    );
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
