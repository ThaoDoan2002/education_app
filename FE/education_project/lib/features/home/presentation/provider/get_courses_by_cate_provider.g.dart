// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_courses_by_cate_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$coursesByCateHash() => r'637d7cb8bbcf28e4c45f72f01dac744691f41652';

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

/// See also [coursesByCate].
@ProviderFor(coursesByCate)
const coursesByCateProvider = CoursesByCateFamily();

/// See also [coursesByCate].
class CoursesByCateFamily extends Family<AsyncValue<List<CourseEntity>>> {
  /// See also [coursesByCate].
  const CoursesByCateFamily();

  /// See also [coursesByCate].
  CoursesByCateProvider call(
    int id,
  ) {
    return CoursesByCateProvider(
      id,
    );
  }

  @override
  CoursesByCateProvider getProviderOverride(
    covariant CoursesByCateProvider provider,
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
  String? get name => r'coursesByCateProvider';
}

/// See also [coursesByCate].
class CoursesByCateProvider extends FutureProvider<List<CourseEntity>> {
  /// See also [coursesByCate].
  CoursesByCateProvider(
    int id,
  ) : this._internal(
          (ref) => coursesByCate(
            ref as CoursesByCateRef,
            id,
          ),
          from: coursesByCateProvider,
          name: r'coursesByCateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$coursesByCateHash,
          dependencies: CoursesByCateFamily._dependencies,
          allTransitiveDependencies:
              CoursesByCateFamily._allTransitiveDependencies,
          id: id,
        );

  CoursesByCateProvider._internal(
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
    FutureOr<List<CourseEntity>> Function(CoursesByCateRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CoursesByCateProvider._internal(
        (ref) => create(ref as CoursesByCateRef),
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
  FutureProviderElement<List<CourseEntity>> createElement() {
    return _CoursesByCateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CoursesByCateProvider && other.id == id;
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
mixin CoursesByCateRef on FutureProviderRef<List<CourseEntity>> {
  /// The parameter `id` of this provider.
  int get id;
}

class _CoursesByCateProviderElement
    extends FutureProviderElement<List<CourseEntity>> with CoursesByCateRef {
  _CoursesByCateProviderElement(super.provider);

  @override
  int get id => (origin as CoursesByCateProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
