// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emoji.dart';

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

String $EmojiServiceHash() => r'3ea5bc1f1b85e9c508fb71154a50ddeaeba57399';

/// See also [EmojiService].
class EmojiServiceProvider
    extends AsyncNotifierProviderImpl<EmojiService, List<EmojiCategory>> {
  EmojiServiceProvider(
    this.key,
  ) : super(
          () => EmojiService()..key = key,
          from: emojiServiceProvider,
          name: r'emojiServiceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : $EmojiServiceHash,
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
    covariant _$EmojiService notifier,
  ) {
    return notifier.build(
      key,
    );
  }
}

typedef EmojiServiceRef = AsyncNotifierProviderRef<List<EmojiCategory>>;

/// See also [EmojiService].
final emojiServiceProvider = EmojiServiceFamily();

class EmojiServiceFamily extends Family<AsyncValue<List<EmojiCategory>>> {
  EmojiServiceFamily();

  EmojiServiceProvider call(
    AccountKey key,
  ) {
    return EmojiServiceProvider(
      key,
    );
  }

  @override
  AsyncNotifierProviderImpl<EmojiService, List<EmojiCategory>>
      getProviderOverride(
    covariant EmojiServiceProvider provider,
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
  String? get name => r'emojiServiceProvider';
}

abstract class _$EmojiService
    extends BuildlessAsyncNotifier<List<EmojiCategory>> {
  late final AccountKey key;

  FutureOr<List<EmojiCategory>> build(
    AccountKey key,
  );
}
