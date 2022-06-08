// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart' as pffi;

import 'dart_md4c_bindings.dart' show MD_CHAR, MD_SIZE;

class DartMd4cHtmlBindings {
  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(
    String symbolName,
  ) _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  DartMd4cHtmlBindings(ffi.DynamicLibrary dynamicLibrary)
      : _lookup = dynamicLibrary.lookup;

  /// The symbols are looked up with [lookup].
  DartMd4cHtmlBindings.fromLookup(
    ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName) lookup,
  ) : _lookup = lookup;

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
  int md_html(
    ffi.Pointer<pffi.Utf8> input,
    int input_size,
    ffi.Pointer<
            ffi.NativeFunction<
                ffi.Void Function(
                    ffi.Pointer<pffi.Utf8>, MD_SIZE, ffi.Pointer<ffi.Void>)>>
        process_output,
    ffi.Pointer<ffi.Void> userdata,
    int parser_flags,
    int renderer_flags,
  ) {
    return _md_html(
      input,
      input_size,
      process_output,
      userdata,
      parser_flags,
      renderer_flags,
    );
  }

  late final _md_htmlPtr = _lookup<
      ffi.NativeFunction<
          ffi.Int32 Function(
              ffi.Pointer<pffi.Utf8>,
              MD_SIZE,
              ffi.Pointer<
                  ffi.NativeFunction<
                      ffi.Void Function(ffi.Pointer<pffi.Utf8>, MD_SIZE,
                          ffi.Pointer<ffi.Void>)>>,
              ffi.Pointer<ffi.Void>,
              ffi.Uint32,
              ffi.Uint32)>>('md_html');

  late final _md_html = _md_htmlPtr.asFunction<
      int Function(
          ffi.Pointer<pffi.Utf8>,
          int,
          ffi.Pointer<
              ffi.NativeFunction<
                  ffi.Void Function(
                      ffi.Pointer<pffi.Utf8>, MD_SIZE, ffi.Pointer<ffi.Void>)>>,
          ffi.Pointer<ffi.Void>,
          int,
          int)>();
}

/// If set, debug output from md_parse() is sent to stderr.
const MD_HTML_FLAG_DEBUG = 0x0001;
const MD_HTML_FLAG_VERBATIM_ENTITIES = 0x0002;
const MD_HTML_FLAG_SKIP_UTF8_BOM = 0x0004;
const MD_HTML_FLAG_XHTML = 0x0008;
