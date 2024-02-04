// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$routerNotifierHash() => r'fc7daa2ca8cc676f438c8a9400b972ce27a7511d';

/// See also [RouterNotifier].
@ProviderFor(RouterNotifier)
final routerNotifierProvider =
    NotifierProvider<RouterNotifier, AccountKey?>.internal(
  RouterNotifier.new,
  name: r'routerNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$routerNotifierHash,
  dependencies: <ProviderOrFamily>[accountManagerProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    accountManagerProvider,
    ...?accountManagerProvider.allTransitiveDependencies
  },
);

typedef _$RouterNotifier = Notifier<AccountKey?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
