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

/// Employee's performance reviews (by user_id)
///
/// Copied from [performanceList].
@ProviderFor(performanceList)
const performanceListProvider = PerformanceListFamily();

/// Employee's performance reviews (by user_id)
///
/// Copied from [performanceList].
class PerformanceListFamily extends Family<AsyncValue<List<PerformanceModel>>> {
  /// Employee's performance reviews (by user_id)
  ///
  /// Copied from [performanceList].
  const PerformanceListFamily();

  /// Employee's performance reviews (by user_id)
  ///
  /// Copied from [performanceList].
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

/// Employee's performance reviews (by user_id)
///
/// Copied from [performanceList].
class PerformanceListProvider
    extends AutoDisposeFutureProvider<List<PerformanceModel>> {
  /// Employee's performance reviews (by user_id)
  ///
  /// Copied from [performanceList].
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

String _$managerPerformanceListHash() =>
    r'cbcf45403e118217621f15b70e12e91b3eb3bb42';

/// Manager's created performance reviews (by manager_id)
///
/// Copied from [managerPerformanceList].
@ProviderFor(managerPerformanceList)
const managerPerformanceListProvider = ManagerPerformanceListFamily();

/// Manager's created performance reviews (by manager_id)
///
/// Copied from [managerPerformanceList].
class ManagerPerformanceListFamily
    extends Family<AsyncValue<List<PerformanceModel>>> {
  /// Manager's created performance reviews (by manager_id)
  ///
  /// Copied from [managerPerformanceList].
  const ManagerPerformanceListFamily();

  /// Manager's created performance reviews (by manager_id)
  ///
  /// Copied from [managerPerformanceList].
  ManagerPerformanceListProvider call(String managerId) {
    return ManagerPerformanceListProvider(managerId);
  }

  @override
  ManagerPerformanceListProvider getProviderOverride(
    covariant ManagerPerformanceListProvider provider,
  ) {
    return call(provider.managerId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'managerPerformanceListProvider';
}

/// Manager's created performance reviews (by manager_id)
///
/// Copied from [managerPerformanceList].
class ManagerPerformanceListProvider
    extends AutoDisposeFutureProvider<List<PerformanceModel>> {
  /// Manager's created performance reviews (by manager_id)
  ///
  /// Copied from [managerPerformanceList].
  ManagerPerformanceListProvider(String managerId)
    : this._internal(
        (ref) =>
            managerPerformanceList(ref as ManagerPerformanceListRef, managerId),
        from: managerPerformanceListProvider,
        name: r'managerPerformanceListProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$managerPerformanceListHash,
        dependencies: ManagerPerformanceListFamily._dependencies,
        allTransitiveDependencies:
            ManagerPerformanceListFamily._allTransitiveDependencies,
        managerId: managerId,
      );

  ManagerPerformanceListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.managerId,
  }) : super.internal();

  final String managerId;

  @override
  Override overrideWith(
    FutureOr<List<PerformanceModel>> Function(
      ManagerPerformanceListRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ManagerPerformanceListProvider._internal(
        (ref) => create(ref as ManagerPerformanceListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        managerId: managerId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<PerformanceModel>> createElement() {
    return _ManagerPerformanceListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ManagerPerformanceListProvider &&
        other.managerId == managerId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, managerId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ManagerPerformanceListRef
    on AutoDisposeFutureProviderRef<List<PerformanceModel>> {
  /// The parameter `managerId` of this provider.
  String get managerId;
}

class _ManagerPerformanceListProviderElement
    extends AutoDisposeFutureProviderElement<List<PerformanceModel>>
    with ManagerPerformanceListRef {
  _ManagerPerformanceListProviderElement(super.provider);

  @override
  String get managerId => (origin as ManagerPerformanceListProvider).managerId;
}

String _$insertPerformanceHash() => r'b022fae470c5887f889fdcc5d68250dbe096275d';

/// Insert a new performance record
///
/// Copied from [insertPerformance].
@ProviderFor(insertPerformance)
const insertPerformanceProvider = InsertPerformanceFamily();

/// Insert a new performance record
///
/// Copied from [insertPerformance].
class InsertPerformanceFamily extends Family<AsyncValue<PerformanceModel>> {
  /// Insert a new performance record
  ///
  /// Copied from [insertPerformance].
  const InsertPerformanceFamily();

  /// Insert a new performance record
  ///
  /// Copied from [insertPerformance].
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

/// Insert a new performance record
///
/// Copied from [insertPerformance].
class InsertPerformanceProvider
    extends AutoDisposeFutureProvider<PerformanceModel> {
  /// Insert a new performance record
  ///
  /// Copied from [insertPerformance].
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

String _$updatePerformanceHash() => r'48faae9996a54214c31e9ea8cdb966c4eddf4a15';

/// Update an existing performance record
///
/// Copied from [updatePerformance].
@ProviderFor(updatePerformance)
const updatePerformanceProvider = UpdatePerformanceFamily();

/// Update an existing performance record
///
/// Copied from [updatePerformance].
class UpdatePerformanceFamily extends Family<AsyncValue<PerformanceModel>> {
  /// Update an existing performance record
  ///
  /// Copied from [updatePerformance].
  const UpdatePerformanceFamily();

  /// Update an existing performance record
  ///
  /// Copied from [updatePerformance].
  UpdatePerformanceProvider call(PerformanceModel performance) {
    return UpdatePerformanceProvider(performance);
  }

  @override
  UpdatePerformanceProvider getProviderOverride(
    covariant UpdatePerformanceProvider provider,
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
  String? get name => r'updatePerformanceProvider';
}

/// Update an existing performance record
///
/// Copied from [updatePerformance].
class UpdatePerformanceProvider
    extends AutoDisposeFutureProvider<PerformanceModel> {
  /// Update an existing performance record
  ///
  /// Copied from [updatePerformance].
  UpdatePerformanceProvider(PerformanceModel performance)
    : this._internal(
        (ref) => updatePerformance(ref as UpdatePerformanceRef, performance),
        from: updatePerformanceProvider,
        name: r'updatePerformanceProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$updatePerformanceHash,
        dependencies: UpdatePerformanceFamily._dependencies,
        allTransitiveDependencies:
            UpdatePerformanceFamily._allTransitiveDependencies,
        performance: performance,
      );

  UpdatePerformanceProvider._internal(
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
    FutureOr<PerformanceModel> Function(UpdatePerformanceRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UpdatePerformanceProvider._internal(
        (ref) => create(ref as UpdatePerformanceRef),
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
    return _UpdatePerformanceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UpdatePerformanceProvider &&
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
mixin UpdatePerformanceRef on AutoDisposeFutureProviderRef<PerformanceModel> {
  /// The parameter `performance` of this provider.
  PerformanceModel get performance;
}

class _UpdatePerformanceProviderElement
    extends AutoDisposeFutureProviderElement<PerformanceModel>
    with UpdatePerformanceRef {
  _UpdatePerformanceProviderElement(super.provider);

  @override
  PerformanceModel get performance =>
      (origin as UpdatePerformanceProvider).performance;
}

String _$deletePerformanceHash() => r'2b338edbae5986613900a2c69557587609d31613';

/// Delete a performance record
///
/// Copied from [deletePerformance].
@ProviderFor(deletePerformance)
const deletePerformanceProvider = DeletePerformanceFamily();

/// Delete a performance record
///
/// Copied from [deletePerformance].
class DeletePerformanceFamily extends Family<AsyncValue<void>> {
  /// Delete a performance record
  ///
  /// Copied from [deletePerformance].
  const DeletePerformanceFamily();

  /// Delete a performance record
  ///
  /// Copied from [deletePerformance].
  DeletePerformanceProvider call(String performanceId) {
    return DeletePerformanceProvider(performanceId);
  }

  @override
  DeletePerformanceProvider getProviderOverride(
    covariant DeletePerformanceProvider provider,
  ) {
    return call(provider.performanceId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'deletePerformanceProvider';
}

/// Delete a performance record
///
/// Copied from [deletePerformance].
class DeletePerformanceProvider extends AutoDisposeFutureProvider<void> {
  /// Delete a performance record
  ///
  /// Copied from [deletePerformance].
  DeletePerformanceProvider(String performanceId)
    : this._internal(
        (ref) => deletePerformance(ref as DeletePerformanceRef, performanceId),
        from: deletePerformanceProvider,
        name: r'deletePerformanceProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$deletePerformanceHash,
        dependencies: DeletePerformanceFamily._dependencies,
        allTransitiveDependencies:
            DeletePerformanceFamily._allTransitiveDependencies,
        performanceId: performanceId,
      );

  DeletePerformanceProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.performanceId,
  }) : super.internal();

  final String performanceId;

  @override
  Override overrideWith(
    FutureOr<void> Function(DeletePerformanceRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DeletePerformanceProvider._internal(
        (ref) => create(ref as DeletePerformanceRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        performanceId: performanceId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _DeletePerformanceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DeletePerformanceProvider &&
        other.performanceId == performanceId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, performanceId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DeletePerformanceRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `performanceId` of this provider.
  String get performanceId;
}

class _DeletePerformanceProviderElement
    extends AutoDisposeFutureProviderElement<void>
    with DeletePerformanceRef {
  _DeletePerformanceProviderElement(super.provider);

  @override
  String get performanceId =>
      (origin as DeletePerformanceProvider).performanceId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
