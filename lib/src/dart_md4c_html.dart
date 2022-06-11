import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

import 'dart_md4c_bindings.dart';
import 'dart_md4c_html_bindings.dart';

const String _libName = 'md4c-html';

// Since the Pod will result in one Framework containing md4c and md4c-html, the
// name will be the same in both bindings.
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

/// Render Markdown into HTML.
///
/// Note only contents of `<body>` tag is generated. Caller must generate
/// HTML header/footer manually before/after calling `md_html()`.
///
/// Params input and input_size specify the Markdown input.
/// Callback process_output() gets called with chunks of HTML output.
/// (Typical implementation may just output the bytes to a file or append to
/// some buffer).
/// Param userdata is just propagated back to `process_output()` callback.
/// Param parser_flags are flags from md4c.h propagated to `md_parse()`.
/// Param render_flags is bitmask of MD_HTML_FLAG_xxxx.
///
/// Returns -1 on error (if `md_parse()` fails.)
/// Returns 0 on success.
int mdHtml(
  String input,
  Pointer<
          NativeFunction<
              Void Function(
                  Pointer<Utf8> html, Uint32 size, Pointer<Void> userdata)>>
      callbackPointer, {
  int parserFlags = 0,
  int rendererFlags = 0,
}) {
  return _bindings.md_html(
    input.toNativeUtf8(),
    input.length,
    callbackPointer,
    Pointer.fromAddress(0),
    parserFlags,
    rendererFlags,
  );
}
