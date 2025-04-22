// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$notesHash() => r'fa162459792a0f2789a22a356aa68ab0dbfd78af';

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

/// See also [notes].
@ProviderFor(notes)
const notesProvider = NotesFamily();

/// See also [notes].
class NotesFamily extends Family<AsyncValue<List<NoteEntity>>> {
  /// See also [notes].
  const NotesFamily();

  /// See also [notes].
  NotesProvider call(
    int id,
  ) {
    return NotesProvider(
      id,
    );
  }

  @override
  NotesProvider getProviderOverride(
    covariant NotesProvider provider,
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
  String? get name => r'notesProvider';
}

/// See also [notes].
class NotesProvider extends AutoDisposeFutureProvider<List<NoteEntity>> {
  /// See also [notes].
  NotesProvider(
    int id,
  ) : this._internal(
          (ref) => notes(
            ref as NotesRef,
            id,
          ),
          from: notesProvider,
          name: r'notesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$notesHash,
          dependencies: NotesFamily._dependencies,
          allTransitiveDependencies: NotesFamily._allTransitiveDependencies,
          id: id,
        );

  NotesProvider._internal(
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
    FutureOr<List<NoteEntity>> Function(NotesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: NotesProvider._internal(
        (ref) => create(ref as NotesRef),
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
  AutoDisposeFutureProviderElement<List<NoteEntity>> createElement() {
    return _NotesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NotesProvider && other.id == id;
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
mixin NotesRef on AutoDisposeFutureProviderRef<List<NoteEntity>> {
  /// The parameter `id` of this provider.
  int get id;
}

class _NotesProviderElement
    extends AutoDisposeFutureProviderElement<List<NoteEntity>> with NotesRef {
  _NotesProviderElement(super.provider);

  @override
  int get id => (origin as NotesProvider).id;
}

String _$noteNotifierHash() => r'48ac6fe04763704e36c9de90f595069a323695f1';

/// See also [NoteNotifier].
@ProviderFor(NoteNotifier)
final noteNotifierProvider = NotifierProvider<NoteNotifier, NoteState>.internal(
  NoteNotifier.new,
  name: r'noteNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$noteNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NoteNotifier = Notifier<NoteState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
