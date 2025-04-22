// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$checkoutHash() => r'113c92ba6e9c2c1c983ad85ac9c549a1aae53ed7';

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

/// See also [checkout].
@ProviderFor(checkout)
const checkoutProvider = CheckoutFamily();

/// See also [checkout].
class CheckoutFamily extends Family<AsyncValue<String?>> {
  /// See also [checkout].
  const CheckoutFamily();

  /// See also [checkout].
  CheckoutProvider call(
    int courseId,
  ) {
    return CheckoutProvider(
      courseId,
    );
  }

  @override
  CheckoutProvider getProviderOverride(
    covariant CheckoutProvider provider,
  ) {
    return call(
      provider.courseId,
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
  String? get name => r'checkoutProvider';
}

/// See also [checkout].
class CheckoutProvider extends AutoDisposeFutureProvider<String?> {
  /// See also [checkout].
  CheckoutProvider(
    int courseId,
  ) : this._internal(
          (ref) => checkout(
            ref as CheckoutRef,
            courseId,
          ),
          from: checkoutProvider,
          name: r'checkoutProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$checkoutHash,
          dependencies: CheckoutFamily._dependencies,
          allTransitiveDependencies: CheckoutFamily._allTransitiveDependencies,
          courseId: courseId,
        );

  CheckoutProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.courseId,
  }) : super.internal();

  final int courseId;

  @override
  Override overrideWith(
    FutureOr<String?> Function(CheckoutRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CheckoutProvider._internal(
        (ref) => create(ref as CheckoutRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        courseId: courseId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<String?> createElement() {
    return _CheckoutProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CheckoutProvider && other.courseId == courseId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, courseId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CheckoutRef on AutoDisposeFutureProviderRef<String?> {
  /// The parameter `courseId` of this provider.
  int get courseId;
}

class _CheckoutProviderElement extends AutoDisposeFutureProviderElement<String?>
    with CheckoutRef {
  _CheckoutProviderElement(super.provider);

  @override
  int get courseId => (origin as CheckoutProvider).courseId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
