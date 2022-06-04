import 'dart:ffi' as ffi;

class DartMd4cBindings {
  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(
    String symbolName,
  ) _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  DartMd4cBindings(ffi.DynamicLibrary dynamicLibrary)
      : _lookup = dynamicLibrary.lookup;

  /// The symbols are looked up with [lookup].
  DartMd4cBindings.fromLookup(
    ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName) lookup,
  ) : _lookup = lookup;
}
