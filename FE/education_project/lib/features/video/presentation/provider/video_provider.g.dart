// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$videoHash() => r'd914ecec4d0516669019992e580fb8ddc8f72b3d';

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

/// See also [video].
@ProviderFor(video)
const videoProvider = VideoFamily();

/// See also [video].
class VideoFamily extends Family<AsyncValue<VideoEntity>> {
  /// See also [video].
  const VideoFamily();

  /// See also [video].
  VideoProvider call(
    int id,
  ) {
    return VideoProvider(
      id,
    );
  }

  @override
  VideoProvider getProviderOverride(
    covariant VideoProvider provider,
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
  String? get name => r'videoProvider';
}

/// See also [video].
class VideoProvider extends FutureProvider<VideoEntity> {
  /// See also [video].
  VideoProvider(
    int id,
  ) : this._internal(
          (ref) => video(
            ref as VideoRef,
            id,
          ),
          from: videoProvider,
          name: r'videoProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$videoHash,
          dependencies: VideoFamily._dependencies,
          allTransitiveDependencies: VideoFamily._allTransitiveDependencies,
          id: id,
        );

  VideoProvider._internal(
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
    FutureOr<VideoEntity> Function(VideoRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: VideoProvider._internal(
        (ref) => create(ref as VideoRef),
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
  FutureProviderElement<VideoEntity> createElement() {
    return _VideoProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is VideoProvider && other.id == id;
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
mixin VideoRef on FutureProviderRef<VideoEntity> {
  /// The parameter `id` of this provider.
  int get id;
}

class _VideoProviderElement extends FutureProviderElement<VideoEntity>
    with VideoRef {
  _VideoProviderElement(super.provider);

  @override
  int get id => (origin as VideoProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
