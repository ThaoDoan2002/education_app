// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_own_course_by_cate_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$coursesOwnByCateHash() => r'bd8cc48c468d1be530defb6f77d1d2c779562d38';

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

/// See also [coursesOwnByCate].
@ProviderFor(coursesOwnByCate)
const coursesOwnByCateProvider = CoursesOwnByCateFamily();

/// See also [coursesOwnByCate].
class CoursesOwnByCateFamily extends Family<AsyncValue<List<CourseEntity>?>> {
  /// See also [coursesOwnByCate].
  const CoursesOwnByCateFamily();

  /// See also [coursesOwnByCate].
  CoursesOwnByCateProvider call(
    int id,
  ) {
    return CoursesOwnByCateProvider(
      id,
    );
  }

  @override
  CoursesOwnByCateProvider getProviderOverride(
    covariant CoursesOwnByCateProvider provider,
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
  String? get name => r'coursesOwnByCateProvider';
}

/// See also [coursesOwnByCate].
class CoursesOwnByCateProvider extends FutureProvider<List<CourseEntity>?> {
  /// See also [coursesOwnByCate].
  CoursesOwnByCateProvider(
    int id,
  ) : this._internal(
          (ref) => coursesOwnByCate(
            ref as CoursesOwnByCateRef,
            id,
          ),
          from: coursesOwnByCateProvider,
          name: r'coursesOwnByCateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$coursesOwnByCateHash,
          dependencies: CoursesOwnByCateFamily._dependencies,
          allTransitiveDependencies:
              CoursesOwnByCateFamily._allTransitiveDependencies,
          id: id,
        );

  CoursesOwnByCateProvider._internal(
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
    FutureOr<List<CourseEntity>?> Function(CoursesOwnByCateRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CoursesOwnByCateProvider._internal(
        (ref) => create(ref as CoursesOwnByCateRef),
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
  FutureProviderElement<List<CourseEntity>?> createElement() {
    return _CoursesOwnByCateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CoursesOwnByCateProvider && other.id == id;
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
mixin CoursesOwnByCateRef on FutureProviderRef<List<CourseEntity>?> {
  /// The parameter `id` of this provider.
  int get id;
}

class _CoursesOwnByCateProviderElement
    extends FutureProviderElement<List<CourseEntity>?>
    with CoursesOwnByCateRef {
  _CoursesOwnByCateProviderElement(super.provider);

  @override
  int get id => (origin as CoursesOwnByCateProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
