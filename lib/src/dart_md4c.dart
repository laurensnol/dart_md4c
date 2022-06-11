import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

import 'dart_md4c_bindings.dart';

const String _libName = 'md4c';

// Since the Pod will result in one Framework containing md4c and md4c-html,
// the name will be the same in both bindings.
const String _libNameMacOS = 'dart_md4c';

/// The dynamic library in which the symbols for [DartMd4cBindings] can be found.
final DynamicLibrary _dylib = () {
  if (Platform.isMacOS || Platform.isIOS) {
    return DynamicLibrary.open('$_libNameMacOS.framework/$_libNameMacOS');
  }
  if (Platform.isAndroid || Platform.isLinux) {
    return DynamicLibrary.open('lib$_libName.so');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('$_libName.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();

/// The bindings to the native functions in [_dylib].
final DartMd4cBindings _bindings = DartMd4cBindings(_dylib);

/// Helper function to create an MD_PARSER since Structs can't be constructed
/// inside Dart.
MD_PARSER createParser(
  Pointer<NativeFunction<Int32 Function(Int32, Pointer<Void>, Pointer<Void>)>>
      enterBlock,
  Pointer<NativeFunction<Int32 Function(Int32, Pointer<Void>, Pointer<Void>)>>
      leaveBlock,
  Pointer<NativeFunction<Int32 Function(Int32, Pointer<Void>, Pointer<Void>)>>
      enterSpan,
  Pointer<NativeFunction<Int32 Function(Int32, Pointer<Void>, Pointer<Void>)>>
      leaveSpan,
  Pointer<
          NativeFunction<
              Int32 Function(Int32, Pointer<Utf8>, MD_SIZE, Pointer<Void>)>>
      text,
  Pointer<NativeFunction<Void Function(Pointer<Utf8>, Pointer<Void>)>>
      debugLog, {
  int flags = 0,
}) {
  return _bindings.create_parser(
    flags,
    enterBlock,
    leaveBlock,
    enterSpan,
    leaveSpan,
    text,
    debugLog,
  );
}

/// Parse the Markdown document stored in the string 'text' of size 'size'.
///
/// The parser provides callbacks to be called during the parsing so the
/// caller can render the document on the screen or convert the Markdown to
/// another format.
///
/// Zero is returned on success. If a runtime error occurs (e.g. a memory
/// fails), -1 is returned. If the processing is aborted due any callback
/// returning non-zero, the return value of the callback is returned.
int mdParse(
  String text,
  Pointer<MD_PARSER> parser,
) {
  return _bindings.md_parse(
    text.toNativeUtf8(),
    text.length,
    parser,
    Pointer.fromAddress(0),
  );
}
