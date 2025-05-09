// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$lessonsHash() => r'6317f454dbbb185e84ffe9613ad10a1106a689f2';

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

/// See also [lessons].
@ProviderFor(lessons)
const lessonsProvider = LessonsFamily();

/// See also [lessons].
class LessonsFamily extends Family<AsyncValue<List<LessonEntity>?>> {
  /// See also [lessons].
  const LessonsFamily();

  /// See also [lessons].
  LessonsProvider call(
    int id,
  ) {
    return LessonsProvider(
      id,
    );
  }

  @override
  LessonsProvider getProviderOverride(
    covariant LessonsProvider provider,
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
  String? get name => r'lessonsProvider';
}

/// See also [lessons].
class LessonsProvider extends FutureProvider<List<LessonEntity>?> {
  /// See also [lessons].
  LessonsProvider(
    int id,
  ) : this._internal(
          (ref) => lessons(
            ref as LessonsRef,
            id,
          ),
          from: lessonsProvider,
          name: r'lessonsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$lessonsHash,
          dependencies: LessonsFamily._dependencies,
          allTransitiveDependencies: LessonsFamily._allTransitiveDependencies,
          id: id,
        );

  LessonsProvider._internal(
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
    FutureOr<List<LessonEntity>?> Function(LessonsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LessonsProvider._internal(
        (ref) => create(ref as LessonsRef),
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
  FutureProviderElement<List<LessonEntity>?> createElement() {
    return _LessonsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LessonsProvider && other.id == id;
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
mixin LessonsRef on FutureProviderRef<List<LessonEntity>?> {
  /// The parameter `id` of this provider.
  int get id;
}

class _LessonsProviderElement extends FutureProviderElement<List<LessonEntity>?>
    with LessonsRef {
  _LessonsProviderElement(super.provider);

  @override
  int get id => (origin as LessonsProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
