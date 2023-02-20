// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emoji.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$emojiServiceHash() => r'f49fb3422094cdee597f163a27acb60f264ce4db';

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

abstract class _$EmojiService
    extends BuildlessAsyncNotifier<List<EmojiCategory>> {
  late final AccountKey key;

  FutureOr<List<EmojiCategory>> build(
    AccountKey key,
  );
}

/// See also [EmojiService].
@ProviderFor(EmojiService)
const emojiServiceProvider = EmojiServiceFamily();

/// See also [EmojiService].
class EmojiServiceFamily extends Family<AsyncValue<List<EmojiCategory>>> {
  /// See also [EmojiService].
  const EmojiServiceFamily();

  /// See also [EmojiService].
  EmojiServiceProvider call(
    AccountKey key,
  ) {
    return EmojiServiceProvider(
      key,
    );
  }

  @override
  EmojiServiceProvider getProviderOverride(
    covariant EmojiServiceProvider provider,
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
  String? get name => r'emojiServiceProvider';
}

/// See also [EmojiService].
class EmojiServiceProvider
    extends AsyncNotifierProviderImpl<EmojiService, List<EmojiCategory>> {
  /// See also [EmojiService].
  EmojiServiceProvider(
    this.key,
  ) : super.internal(
          () => EmojiService()..key = key,
          from: emojiServiceProvider,
          name: r'emojiServiceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$emojiServiceHash,
          dependencies: EmojiServiceFamily._dependencies,
          allTransitiveDependencies:
              EmojiServiceFamily._allTransitiveDependencies,
        );

  final AccountKey key;

  @override
  bool operator ==(Object other) {
    return other is EmojiServiceProvider && other.key == key;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, key.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  FutureOr<List<EmojiCategory>> runNotifierBuild(
    covariant EmojiService notifier,
  ) {
    return notifier.build(
      key,
    );
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
