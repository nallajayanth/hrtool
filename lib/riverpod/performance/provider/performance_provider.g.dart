// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'performance_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$performanceListHash() => r'4be8421ed5fc1b16e987bea827fe5e3f92c132e5';

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

/// See also [performanceList].
@ProviderFor(performanceList)
const performanceListProvider = PerformanceListFamily();

/// See also [performanceList].
class PerformanceListFamily extends Family<AsyncValue<List<PerformanceModel>>> {
  /// See also [performanceList].
  const PerformanceListFamily();

  /// See also [performanceList].
  PerformanceListProvider call(String userId) {
    return PerformanceListProvider(userId);
  }

  @override
  PerformanceListProvider getProviderOverride(
    covariant PerformanceListProvider provider,
  ) {
    return call(provider.userId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'performanceListProvider';
}

/// See also [performanceList].
class PerformanceListProvider
    extends AutoDisposeFutureProvider<List<PerformanceModel>> {
  /// See also [performanceList].
  PerformanceListProvider(String userId)
    : this._internal(
        (ref) => performanceList(ref as PerformanceListRef, userId),
        from: performanceListProvider,
        name: r'performanceListProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$performanceListHash,
        dependencies: PerformanceListFamily._dependencies,
        allTransitiveDependencies:
            PerformanceListFamily._allTransitiveDependencies,
        userId: userId,
      );

  PerformanceListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    FutureOr<List<PerformanceModel>> Function(PerformanceListRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PerformanceListProvider._internal(
        (ref) => create(ref as PerformanceListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<PerformanceModel>> createElement() {
    return _PerformanceListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PerformanceListProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PerformanceListRef
    on AutoDisposeFutureProviderRef<List<PerformanceModel>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _PerformanceListProviderElement
    extends AutoDisposeFutureProviderElement<List<PerformanceModel>>
    with PerformanceListRef {
  _PerformanceListProviderElement(super.provider);

  @override
  String get userId => (origin as PerformanceListProvider).userId;
}

String _$insertPerformanceHash() => r'b022fae470c5887f889fdcc5d68250dbe096275d';

/// See also [insertPerformance].
@ProviderFor(insertPerformance)
const insertPerformanceProvider = InsertPerformanceFamily();

/// See also [insertPerformance].
class InsertPerformanceFamily extends Family<AsyncValue<PerformanceModel>> {
  /// See also [insertPerformance].
  const InsertPerformanceFamily();

  /// See also [insertPerformance].
  InsertPerformanceProvider call(PerformanceModel performance) {
    return InsertPerformanceProvider(performance);
  }

  @override
  InsertPerformanceProvider getProviderOverride(
    covariant InsertPerformanceProvider provider,
  ) {
    return call(provider.performance);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'insertPerformanceProvider';
}

/// See also [insertPerformance].
class InsertPerformanceProvider
    extends AutoDisposeFutureProvider<PerformanceModel> {
  /// See also [insertPerformance].
  InsertPerformanceProvider(PerformanceModel performance)
    : this._internal(
        (ref) => insertPerformance(ref as InsertPerformanceRef, performance),
        from: insertPerformanceProvider,
        name: r'insertPerformanceProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$insertPerformanceHash,
        dependencies: InsertPerformanceFamily._dependencies,
        allTransitiveDependencies:
            InsertPerformanceFamily._allTransitiveDependencies,
        performance: performance,
      );

  InsertPerformanceProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.performance,
  }) : super.internal();

  final PerformanceModel performance;

  @override
  Override overrideWith(
    FutureOr<PerformanceModel> Function(InsertPerformanceRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: InsertPerformanceProvider._internal(
        (ref) => create(ref as InsertPerformanceRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        performance: performance,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<PerformanceModel> createElement() {
    return _InsertPerformanceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is InsertPerformanceProvider &&
        other.performance == performance;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, performance.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin InsertPerformanceRef on AutoDisposeFutureProviderRef<PerformanceModel> {
  /// The parameter `performance` of this provider.
  PerformanceModel get performance;
}

class _InsertPerformanceProviderElement
    extends AutoDisposeFutureProviderElement<PerformanceModel>
    with InsertPerformanceRef {
  _InsertPerformanceProviderElement(super.provider);

  @override
  PerformanceModel get performance =>
      (origin as InsertPerformanceProvider).performance;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
