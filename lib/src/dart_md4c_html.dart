import 'dart:ffi';
import 'dart:io';

// Unused right now
// import 'dart:async';
// import 'dart:isolate';

import 'dart_md4c_html_bindings.dart';

const String _libName = 'md4c-html';

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
final DartMd4cHtmlBindings _bindings = DartMd4cHtmlBindings(_dylib);
