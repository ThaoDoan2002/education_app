// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_cate_by_ID_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$categoryHash() => r'87f43dcc4a72517aeac64212540a4550444406ab';

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

/// See also [category].
@ProviderFor(category)
const categoryProvider = CategoryFamily();

/// See also [category].
class CategoryFamily extends Family<AsyncValue<CategoryEntity?>> {
  /// See also [category].
  const CategoryFamily();

  /// See also [category].
  CategoryProvider call(
    int id,
  ) {
    return CategoryProvider(
      id,
    );
  }

  @override
  CategoryProvider getProviderOverride(
    covariant CategoryProvider provider,
  ) {
    return call(
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
  String? get name => r'categoryProvider';
}

/// See also [category].
class CategoryProvider extends AutoDisposeFutureProvider<CategoryEntity?> {
  /// See also [category].
  CategoryProvider(
    int id,
  ) : this._internal(
          (ref) => category(
            ref as CategoryRef,
            id,
          ),
          from: categoryProvider,
          name: r'categoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$categoryHash,
          dependencies: CategoryFamily._dependencies,
          allTransitiveDependencies: CategoryFamily._allTransitiveDependencies,
          id: id,
        );

  CategoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  Override overrideWith(
    FutureOr<CategoryEntity?> Function(CategoryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CategoryProvider._internal(
        (ref) => create(ref as CategoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<CategoryEntity?> createElement() {
    return _CategoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CategoryProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CategoryRef on AutoDisposeFutureProviderRef<CategoryEntity?> {
  /// The parameter `id` of this provider.
  int get id;
}

class _CategoryProviderElement
    extends AutoDisposeFutureProviderElement<CategoryEntity?> with CategoryRef {
  _CategoryProviderElement(super.provider);

  @override
  int get id => (origin as CategoryProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
